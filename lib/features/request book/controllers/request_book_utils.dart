import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librrr_management/data/models/requested_books/request_book_class.dart';
import 'package:librrr_management/features/books/pages/src_add_book.dart';
import 'package:librrr_management/features/request%20book/provider/request_book_provider.dart';
import 'package:librrr_management/core/helpers/about_test_style.dart';
import 'package:librrr_management/core/helpers/snackbar_for_all.dart';

class ConfirmStockedBookDialog extends ConsumerWidget {
  final RequestBookClass bookInfo;
  const ConfirmStockedBookDialog({super.key, required this.bookInfo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Confirm book is stocked'),
      content: const Text('Are you sure this book is stocked in library'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: Theme.of(context).textTheme.bodyLarge),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          onPressed: () async {
            await ref.read(requestedBooksListProvider.notifier).removeRequest(bookInfo);
            if (!context.mounted) return;
            Navigator.pop(context);
            SnackBarForAll.showSuccess(context, 'Succesfully deleted');
            clearNavigateToHome(AddBooks(reBookDetails: bookInfo), context);
          },
          child: Text('Ok', style: Theme.of(context).textTheme.bodyLarge),
        )
      ],
    );
  }
}