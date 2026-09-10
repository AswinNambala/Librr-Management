import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/data/models/finished_books/finished_book_class.dart';
import 'package:librrr_management/data/models/members/members_class.dart';
import 'package:librrr_management/data/respository/member_respository.dart';

final membersRepositoryProvider = Provider<MembersRepository>((ref) {
  return MembersRepository(Hive.box<MemberClass>('members'));
});


final membersListProvider =
    StateNotifierProvider<MembersListNotifier, List<MemberClass>>((ref) {
  return MembersListNotifier(ref.watch(membersRepositoryProvider));
});

class MembersListNotifier extends StateNotifier<List<MemberClass>> {
  MembersListNotifier(this._repo) : super(_repo.getAll()) {
    _sub = _repo.watch().listen((_) => state = _repo.getAll());
  }

  final MembersRepository _repo;
  late final StreamSubscription _sub;

  Future<String?> addMember(MemberClass member) async {
    final error = _validate(member);
    if (error != null) return error;
    await _repo.add(member);
    return null;
  }

  Future<String?> updateMember(MemberClass original, MemberClass edited) async {
    final error = _validate(edited);
    if (error != null) return error;
    await _repo.update(original, edited);
    return null;
  }

  Future<void> deleteMember(MemberClass member) => _repo.delete(member);

  String? _validate(MemberClass m) {
    if (m.mFirstName.isEmpty ||
        m.mLastName.isEmpty ||
        m.mAddress.isEmpty ||
        m.mPincode.isEmpty ||
        m.mPhoneNumber.isEmpty ||
        m.mGender.isEmpty ||
        m.mPlan.isEmpty ||
        m.mMembersId.isEmpty ||
        m.mJoinDate.isEmpty ||
        m.mExpireDate.isEmpty) {
      return 'Complete all fields';
    }
    return null;
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

// List screen UI state

final membersSearchQueryProvider = StateProvider<String>((ref) => '');
final membersGridViewProvider = StateProvider<bool>((ref) => true);

final filteredMembersProvider = Provider<List<MemberClass>>((ref) {
  final members = ref.watch(membersListProvider);
  final query = ref.watch(membersSearchQueryProvider).trim().toLowerCase();
  if (query.isEmpty) return members;
  return members.where((m) {
    final name = '${m.mFirstName} ${m.mLastName}'.toLowerCase();
    return name.contains(query) || m.mMembersId.toLowerCase().contains(query);
  }).toList();
});

// Member profile screen — live books-in-hand / finished books

final memberBooksInHandProvider =
    StreamProvider.family<List<BorrowedBookClass>, String>((ref, memberId) async* {
  final box = Hive.box<BorrowedBookClass>('borrowedBooks');
  List<BorrowedBookClass> read() =>
      box.values.where((b) => b.memberId == memberId).toList();
  yield read();
  yield* box.watch().map((_) => read());
});

final memberFinishedBooksProvider =
    StreamProvider.family<List<FinishedBookClass>, String>((ref, memberId) async* {
  final box = Hive.box<FinishedBookClass>('finishedBooks');
  List<FinishedBookClass> read() =>
      box.values.where((b) => b.memberId == memberId).toList();
  yield read();
  yield* box.watch().map((_) => read());
});

int memberTotalFine(List<FinishedBookClass> finishedBooks) {
  int sum = 0;
  for (final book in finishedBooks) {
    final amount = int.tryParse(book.fineAmount.trim());
    if (amount != null) sum += amount;
  }
  return sum;
}

List<FinishedBookClass> memberFineOnlyBooks(List<FinishedBookClass> finishedBooks) {
  return finishedBooks.where((b) {
    final amount = int.tryParse(b.fineAmount.trim());
    return amount != null && amount > 0;
  }).toList();
}

int? memberRemainingDays(String expireDate) {
  try {
    final formatter = DateFormat('dd-MM-yyyy');
    final parsed = formatter.parseStrict(expireDate);
    return parsed.difference(DateTime.now()).inDays;
  } on FormatException {
    return null;
  }
}