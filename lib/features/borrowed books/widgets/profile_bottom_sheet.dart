import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/core/helpers/menu_options.dart';

// bottom sheet for borrowed book profile to view profile full detials
void borrowedBooksProfileBottomSheet(
    BuildContext context, BorrowedBookClass books, int keyIndex) {
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final DateTime expireDate = formatter.parse(books.returnDate);
  final int remainDate = expireDate.difference(DateTime.now()).inDays;
  int nRemainingDate = remainDate.abs();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    backgroundColor: Theme.of(context).colorScheme.onTertiary,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Borrowed Book Details',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: const Icon(
                    Icons.menu_book,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            books.bookName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          BorrowedBookOptionsMenu(
                            remainDays: remainDate,
                            borrowedBookData: books,
                            index: keyIndex,
                            borrowedBookBox:
                                Hive.box<BorrowedBookClass>('borrowedBooks'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        books.bookId,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title:  Text("Language", style: Theme.of(context).textTheme.bodyLarge,),
              trailing: Text(
                books.bookLanguage,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title:  Text("Member Name", style: Theme.of(context).textTheme.bodyLarge,),
              trailing: Text(
                books.memberName,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title:  Text("Member ID", style: Theme.of(context).textTheme.bodyLarge,),
              trailing: Text(
                books.memberId,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title:  Text("Return Date", style: Theme.of(context).textTheme.bodyLarge,),
              trailing: Text(
                books.returnDate,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title:  Text("Remaining Days", style: Theme.of(context).textTheme.bodyLarge,),
              trailing: Text(remainDate > 1?
                "$remainDate days to return" : '$nRemainingDate days late',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}
