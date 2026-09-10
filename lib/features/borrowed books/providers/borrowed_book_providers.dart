import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:librrr_management/data/models/books/books%20_class.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/data/models/finished_books/finished_book_class.dart';
import 'package:librrr_management/data/models/members/members_class.dart';
import 'package:librrr_management/data/respository/book_respository.dart';
import 'package:librrr_management/data/respository/borrowed_book_respository.dart';
import 'package:librrr_management/data/respository/finished_book_respository.dart';
import 'package:librrr_management/data/respository/member_respository.dart';

// Repositories

final borrowedBooksRepositoryProvider =
    Provider<BorrowedBooksRepository>((ref) {
  return BorrowedBooksRepository(Hive.box<BorrowedBookClass>('borrowedBooks'));
});

final membersRepositoryProvider = Provider<MembersRepository>((ref) {
  return MembersRepository(Hive.box<MemberClass>('members'));
});

final booksRepositoryProvider = Provider<BooksRepository>((ref) {
  return BooksRepository(Hive.box<BooksClass>('booksDetials'));
});

final finishedBooksRepositoryProvider =
    Provider<FinishedBooksRepository>((ref) {
  return FinishedBooksRepository(Hive.box<FinishedBookClass>('finishedBooks'));
});

final borrowedBooksListProvider =
    StateNotifierProvider<BorrowedBooksListNotifier, List<BorrowedBookClass>>(
        (ref) {
  return BorrowedBooksListNotifier(
    borrowedRepo: ref.watch(borrowedBooksRepositoryProvider),
    booksRepo: ref.watch(booksRepositoryProvider),
    membersRepo: ref.watch(membersRepositoryProvider),
  );
});

class BorrowedBooksListNotifier extends StateNotifier<List<BorrowedBookClass>> {
  BorrowedBooksListNotifier({
    required BorrowedBooksRepository borrowedRepo,
    required BooksRepository booksRepo,
    required MembersRepository membersRepo,
  })  : _borrowedRepo = borrowedRepo,
        _booksRepo = booksRepo,
        _membersRepo = membersRepo,
        super(borrowedRepo.getAll()) {
    _sub = _borrowedRepo.watch().listen((_) => state = _borrowedRepo.getAll());
  }

  final BorrowedBooksRepository _borrowedRepo;
  final BooksRepository _booksRepo;
  final MembersRepository _membersRepo;
  late final StreamSubscription _sub;

  Future<String?> addBorrowedBook(BorrowedBookClass book) async {
    if (book.bookId.isEmpty ||
        book.bookName.isEmpty ||
        book.bookLanguage.isEmpty ||
        book.memberId.isEmpty ||
        book.memberName.isEmpty ||
        book.borrowedDate.isEmpty ||
        book.returnDate.isEmpty ||
        book.returnDate == 'null-null-null') {
      return 'Complete all fields';
    }
    Future<void> markBookReturned(
      BorrowedBookClass book,
      FinishedBooksRepository finishedRepo,
    ) async {
      final finishedBook = FinishedBookClass(
        book.bookName,
        book.bookId,
        book.memberId,
        book.memberName,
        '',
        book.returnDate,
      );
      await finishedRepo.add(finishedBook);
      await book.delete(); 
      await _booksRepo.incrementStock(book.bookId);
    }

    final member = _membersRepo.findById(book.memberId);
    if (member == null) {
      return 'Member not found';
    }

    final quota = _membersRepo.booksPerMonthFor(book.memberId);
    final activeCount = _borrowedRepo.activeCountForMember(book.memberId);
    if (activeCount >= quota) {
      return 'MEMBER_LIMIT_EXCEEDED';
    }

    final stockOk = await _booksRepo.decrementStock(book.bookId);
    if (!stockOk) {
      return 'This book has no copies available to borrow';
    }

    await _borrowedRepo.add(book);
    return null;
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  Future<void> markBookReturned(BorrowedBookClass borrowedBookData, FinishedBooksRepository finishedRepo) async {}
}

// List screen UI state

final borrowedSearchQueryProvider = StateProvider<String>((ref) => '');
final borrowedGridViewProvider = StateProvider<bool>((ref) => true);

final filteredBorrowedBooksProvider = Provider<List<BorrowedBookClass>>((ref) {
  final books = ref.watch(borrowedBooksListProvider);
  final query = ref.watch(borrowedSearchQueryProvider).trim().toLowerCase();
  if (query.isEmpty) return books;
  return books.where((b) {
    return b.bookName.toLowerCase().contains(query) ||
        b.bookId.toLowerCase().contains(query);
  }).toList();
});

// Member autofill (Add Borrowed Book screen)

class MemberLookupResult {
  final String name;
  final String expireDate;
  const MemberLookupResult({required this.name, required this.expireDate});
  static const empty = MemberLookupResult(name: '', expireDate: '');
}

final memberLookupProvider =
    Provider.family<MemberLookupResult, String>((ref, memberId) {
  if (memberId.isEmpty) return MemberLookupResult.empty;
  final member = ref.watch(membersRepositoryProvider).findById(memberId);
  if (member == null) return MemberLookupResult.empty;
  return MemberLookupResult(
    name: '${member.mFirstName} ${member.mLastName}',
    expireDate: member.mExpireDate,
  );
});

final _dateFormatter = DateFormat('dd-MM-yyyy');

int? borrowedBookRemainingDays(String returnDate) {
  try {
    final expireDate = _dateFormatter.parseStrict(returnDate);
    return expireDate.difference(DateTime.now()).inDays;
  } on FormatException {
    return null;
  }
}

bool borrowedReturnDateExceedsMemberExpiry(
    String returnDateText, String memberExpireText) {
  if (returnDateText.isEmpty || memberExpireText.isEmpty) return false;
  try {
    final returnDate = _dateFormatter.parseStrict(returnDateText.trim());
    final expireDate = _dateFormatter.parseStrict(memberExpireText.trim());
    return returnDate.isAfter(expireDate);
  } on FormatException {
    return false;
  }
}
