import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/data/models/finished_books/finished_book_class.dart';
import 'package:librrr_management/data/models/members/members_class.dart';
import 'package:librrr_management/features/members/pages/src_member_list.dart';
import 'package:librrr_management/core/helpers/snackbar_for_all.dart';

class DbMemberUtils{
  // add members page add new members to db
  static Future<void> addMemberMembersOnPress({
    required BuildContext context,
    required MemberClass newMember,
  }) async {
    final box = Hive.box<MemberClass>('members');

    if (newMember.mFirstName.isEmpty ||
        newMember.mLastName.isEmpty ||
        newMember.mAddress.isEmpty ||
        newMember.mPincode.isEmpty ||
        newMember.mPhoneNumber.isEmpty ||
        newMember.mGender.isEmpty ||
        newMember.mPlan.isEmpty ||
        newMember.mMembersId.isEmpty ||
        newMember.mJoinDate.isEmpty ||
        newMember.mExpireDate.isEmpty) {
      SnackBarForAll.showError(context, 'Complete all fields');
    } else {
      await box.add(newMember);
      if (!context.mounted) return;
      SnackBarForAll.showSuccess(context, 'Member added successfully');
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (context, anim1, anim2) => const MemberList(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ));
    }
  }

 // edit members page update members details to db
  static Future<void> editMemberOnUpdatePressed({
    required BuildContext context,
    required MemberClass oldMember,
    required MemberClass updatedMember,
  }) async {
    final box = Hive.box<MemberClass>('members');
    final index = box.values.toList().indexOf(oldMember);

    if (index != -1) {
      await box.putAt(index, updatedMember);
      if (!context.mounted) return;
      SnackBarForAll.showSuccess(context, "Member updated successfully");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MemberList()),
      );
    } else {
      SnackBarForAll.showError(context, "Update failed. Member not found.");
    }
  }

  // members profile page function for books in hand
  static List<BorrowedBookClass> profileMemberGetBooksInHand(String memberId) {
    final borrowedBookInfo = Hive.box<BorrowedBookClass>('borrowedBooks');
    return borrowedBookInfo.values
        .where((b) => b.memberId == memberId)
        .toList();
  }

  // members profile page function for finished books
  static List<FinishedBookClass> profileMemberGetFinishedBooks(
      String memberId) {
    final bookInfo = Hive.box<FinishedBookClass>('finishedBooks');
    return bookInfo.values.where((a) => a.memberId == memberId).toList();
  }
}