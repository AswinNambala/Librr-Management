import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/data/models/finished_books/finished_book_class.dart';
import 'package:librrr_management/features/borrowed%20books/pages/src_borrowed_lists.dart';
import 'package:librrr_management/core/helpers/about_test_style.dart';

class DbFinishedBookUtils {
   static Future<void> finishedBookSave(
      BuildContext context, FinishedBookClass finishedBook, int index) async {
    final fBook = Hive.box<FinishedBookClass>('finishedBooks');
    final borrowedBook = Hive.box<BorrowedBookClass>('borrowedBooks');
    await fBook.add(finishedBook);
    await borrowedBook.deleteAt(index);
    navigateTo(const BorrowedBooksList(), context);
  }
}