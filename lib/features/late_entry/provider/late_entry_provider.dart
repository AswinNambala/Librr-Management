import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/data/models/finished_books/finished_book_class.dart';
import 'package:librrr_management/features/borrowed%20books/providers/borrowed_book_providers.dart';

/// Days overdue/remaining for a borrowed book's return date.
int? lateEntryFineDays(String returnDate) {
  try {
    final formatter = DateFormat('dd-MM-yyyy');
    final expireDate = formatter.parse(returnDate);
    return expireDate.difference(DateTime.now()).inDays;
  } on FormatException {
    return null;
  }
}

/// ₹5/day fine for days overdue. Returns 0 if the date can't be parsed
int lateEntryFineAmount(String returnDate) {
  final days = lateEntryFineDays(returnDate);
  if (days == null || days >= 0) return 0;
  return days.abs() * 5;
}

class LateEntryNotifier extends StateNotifier<void> {
  LateEntryNotifier(this._ref) : super(null);
  final Ref _ref;

  Future<String?> finalizeLateReturn({
    required BorrowedBookClass borrowedBook,
    required String returnedByMemberId,
    required String returnedByMemberName,
    required String fineAmountText,
    required String returnDateText,
  }) async {
    if (returnDateText.isEmpty ||
        returnedByMemberId.isEmpty ||
        returnedByMemberName.isEmpty ||
        fineAmountText.isEmpty) {
      return 'All field is not completed';
    }

    final finishedRepo = _ref.read(finishedBooksRepositoryProvider);
    final booksRepo = _ref.read(booksRepositoryProvider);

    final lateBook = FinishedBookClass(
      borrowedBook.bookName,
      borrowedBook.bookId,
      returnedByMemberId.trim(),
      returnedByMemberName.trim(),
      fineAmountText.trim(),
      returnDateText.trim(),
    );

    await finishedRepo.add(lateBook);
    await borrowedBook.delete(); 
    await booksRepo.incrementStock(borrowedBook.bookId); 

    return null;
  }
}

final lateEntryNotifierProvider =
    StateNotifierProvider<LateEntryNotifier, void>((ref) {
  return LateEntryNotifier(ref);
});