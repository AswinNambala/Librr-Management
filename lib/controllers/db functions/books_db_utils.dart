import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:librrr_management/models/books/books%20_class.dart';
import 'package:librrr_management/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/models/finished_books/finished_book_class.dart';
import 'package:librrr_management/screens/books/src_list_of_books.dart';
import 'package:librrr_management/widgets/snackbar_for_all.dart';

class DbBooksUtils {
  // add books page save new book db functions
  static Future<void> addBookNewBooks(
      {required BuildContext context, required BooksClass newBook}) async {
    final bookBox = Hive.box<BooksClass>('booksDetials');
    if (newBook.booksName.isEmpty ||
        newBook.authorName.isEmpty ||
        newBook.language.isEmpty ||
        newBook.numberOfBooks.isEmpty ||
        newBook.booksGenre.isEmpty ||
        newBook.bookShelf.isEmpty) {
      SnackBarForAll.showError(context, 'Complete all fields');
    } else {
      await bookBox.add(newBook);
      SnackBarForAll.showSuccess(context, 'New book is added to book shelf ');
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (context, anim1, anim2) => const ListOfBooks(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ));
    }
  }

// edit books page update old books details to db 
  static Future<void> editBookOnUpdatePressed({
    required BuildContext context,
    required BooksClass oldBook,
    required BooksClass updatedBook,
  }) async {
    final box = Hive.box<BooksClass>('booksDetials');
    final index = box.values.toList().indexOf(oldBook);

    if (index != -1) {
      await box.putAt(index, updatedBook);
      if (!context.mounted) return;
      SnackBarForAll.showSuccess(context, "Book updation successfully");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ListOfBooks()),
      );
    } else {
      SnackBarForAll.showError(context, "Update failed. book not found.");
    }
  }

   // function for book profile page books history of members
  static List<FinishedBookClass> bookProflieReadedMembersDetails(
    BuildContext context,
    String bookId,
  ) {
    final box = Hive.box<FinishedBookClass>('finishedBooks');
    return box.values.where((b) => b.bookId == bookId).toList();
  }

  // function for books profile page borrowed members list
  static List<BorrowedBookClass> bookProflieBorrowedMembersDetails(
    BuildContext context,
    String bookId,
  ) {
    final box = Hive.box<BorrowedBookClass>('borrowedBooks');
    return box.values.where((b) => b.bookId == bookId).toList();
  }

}
