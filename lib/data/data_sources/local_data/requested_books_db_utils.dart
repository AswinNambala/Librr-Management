import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:librrr_management/data/models/requested_books/request_book_class.dart';
import 'package:librrr_management/features/request%20book/pages/src_list_of_request_book.dart';
import 'package:librrr_management/core/helpers/snackbar_for_all.dart';

class DbRequestBookUtils {
  // request book page saving members requested book to db
 static Future<void> savingRequestedBooks(
      BuildContext context, RequestBookClass rBooks) async {
    final rBox = Hive.box<RequestBookClass>('requestedBooks');
    if (rBooks.rBookName.isNotEmpty ||
        rBooks.rAuthorName.isNotEmpty ||
        rBooks.rLanguage.isNotEmpty) {
      SnackBarForAll.showSuccess(context, 'Successfully added');
      rBox.add(rBooks);
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (context, anim1, anim2) => const ListOfRequestBook(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ));
    } else {
      SnackBarForAll.showError(context, 'Unsuccessfull');
    }
  }
}