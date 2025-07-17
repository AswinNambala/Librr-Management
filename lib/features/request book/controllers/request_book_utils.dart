import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:librrr_management/data/models/requested_books/request_book_class.dart';
import 'package:librrr_management/features/books/pages/src_add_book.dart';
import 'package:librrr_management/core/helpers/about_test_style.dart';
import 'package:librrr_management/core/helpers/snackbar_for_all.dart';

class RequestBookUtils {
  // all function for adding requested book
  static Widget requestedBooksAddtoBooksClass(
      BuildContext context, int index, RequestBookClass bookInfo) {
    return AlertDialog(
      title: const Text('Conform book is stocked'),
      content: const Text('Are you sure this book is stocked in library'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child:  Text('Cancel', style: Theme.of(context).textTheme.bodyLarge,)),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black
          ),
            onPressed: () {
              final reBox = Hive.box<RequestBookClass>('requestedBooks');
              reBox.delete(index);
              Navigator.pop(context);
              Future.delayed(const Duration(seconds: 2));
              SnackBarForAll.showSuccess(context, 'Succesfully deleted');
              clearNavigateToHome(
                  AddBooks(
                    reBookDetails: bookInfo,
                  ),
                  context);
            },
            child:  Text('Ok', style: Theme.of(context).textTheme.bodyLarge,))
      ],
    );
  }
}
