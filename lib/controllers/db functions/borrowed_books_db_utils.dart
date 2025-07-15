import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:librrr_management/controllers/common%20functions/borrowed_book_utils.dart';
import 'package:librrr_management/models/books/books%20_class.dart';
import 'package:librrr_management/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/screens/borrowed%20books/src_borrowed_lists.dart';
import 'package:librrr_management/widgets/snackbar_for_all.dart';

class DbBorrowedBooksUtils {
  static Future<void> borrowedBookSaveBorrowedBook(
      BuildContext context, BorrowedBookClass borroweBook) async {
    final borrowedBox = Hive.box<BorrowedBookClass>('borrowedBooks');
    final bookBox = Hive.box<BooksClass>('booksDetials');

    if (borroweBook.bookId.isEmpty ||
        borroweBook.bookName.isEmpty ||
        borroweBook.bookLanguage.isEmpty ||
        borroweBook.memberId.isEmpty ||
        borroweBook.memberName.isEmpty ||
        borroweBook.borrowedDate.isEmpty ||
        borroweBook.returnDate.isEmpty ||
        borroweBook.returnDate == 'null-null-null') {
      SnackBarForAll.showError(context, 'Failed to upload borrowed book');
      return;
    } else {
      final bool checking = BorrowedBookUtils.checkMembersValidityForBook(
          borroweBook.memberId, context);
      log('books validation in add borrowed $checking');
      if (checking) {
        borrowedBox.add(borroweBook);
        final bookIndex = bookBox.values.toList().indexWhere(
              (b) => b.bookShelf == borroweBook.bookId,
            );

        if (bookIndex != -1) {
          final book = bookBox.getAt(bookIndex)!;
          book.numberOfBooks = (int.parse(book.numberOfBooks) - 1).toString();
          await bookBox.putAt(bookIndex, book);
        }

        SnackBarForAll.showSuccess(context, 'Marked as borrowed');
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (context, anim1, anim2) => const BorrowedBooksList(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ));
      } else {
        BorrowedBookUtils.showNoteMemberValidityExceeded(context);
      }
    }
  }
}
