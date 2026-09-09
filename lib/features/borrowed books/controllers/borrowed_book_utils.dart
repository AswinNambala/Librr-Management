import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/data/models/members/members_class.dart';
import 'package:librrr_management/features/borrowed%20books/providers/borrowed_book_providers.dart';

class BorrowedBookUtils {
  // all borrowed book adding functions
  static void borrowedBookAutoFillMembersDetails(
      String memberId,
      TextEditingController membersName,
      TextEditingController membersEpireDate) {
    final memberBox = Hive.box<MemberClass>('members');
    final memberDetails = memberBox.values.firstWhere(
      (m) => m.mMembersId == memberId,
      orElse: () =>
          MemberClass(null, '', '', '', '', '', '', '', '', '', '', ''),
    );
    if (memberDetails.mMembersId.isNotEmpty) {
      membersName.text =
          '${memberDetails.mFirstName} ${memberDetails.mLastName}';
      membersEpireDate.text = memberDetails.mExpireDate;
    } else {
      membersName.clear();
      membersEpireDate.clear();
    }
  }

  static bool borrowedBookReturnDateValidate(
      BuildContext context,
      TextEditingController returnDate,
      TextEditingController memberExpireDate) {
    final dateFormater = DateFormat('dd-MM-yyyy');

    if (returnDate.text.isEmpty || memberExpireDate.text.isEmpty) {
      return false;
    }
    final dReturnDate = dateFormater.parseStrict(returnDate.text.trim());
    final dExpireDate = dateFormater.parseStrict(memberExpireDate.text.trim());

    if (dReturnDate.isAfter(dExpireDate)) {
      return true;
    } else {
      return false;
    }
  }

  // function for list of borrowed books
  static int borrowedBookRemainingDateCalculate(
      BuildContext context, BorrowedBookClass borBooks) {
    return borrowedBookRemainingDays(borBooks.returnDate) ?? 9999;
  }

// members number of books validity per month check vailidity for borrowing books
  static bool checkMembersValidityForBook(
      String membersId, BuildContext context) {
    final borBox = Hive.box<BorrowedBookClass>('borrowedBooks');
    final mbox = Hive.box<MemberClass>('members');
    final count = borBox.values.where((b) => b.memberId == membersId).length;
    final memb = mbox.values.firstWhere((m) => m.mMembersId == membersId,
        orElse: () =>
            MemberClass(null, '', '', '', '', '', '', '', '', '', '', ''));
    int numbooks = int.parse(memb.mBooksPerMonth);

    return count < numbooks;
  }
// add borrowed books checking members plan validity period

  static Future<void> showNoteMemberValidityExceeded(
      BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Warning',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              content: Text(
                'You have reached your monthly book limit. Please return a book or upgrade your plan to borrow more books.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Ok',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ))
              ],
            ));
  }
}
