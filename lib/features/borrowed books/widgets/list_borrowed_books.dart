import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:librrr_management/features/borrowed%20books/controllers/borrowed_book_utils.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/features/borrowed%20books/widgets/profile_bottom_sheet.dart';
import 'package:librrr_management/core/helpers/menu_options.dart';

// list of borrowed books gird view design
Widget borrowedBuildGridViewBuilder(
    BuildContext context, BorrowedBookClass borrowedBookInfo, int index) {
  final remainingDate = BorrowedBookUtils.borrowedBookRemainingDateCalculate(
      context, borrowedBookInfo);

  return InkWell(
    onTap: () {
      borrowedBooksProfileBottomSheet(context, borrowedBookInfo, index);
    },
    child: Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).cardTheme.color,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Theme.of(context).colorScheme.onTertiary,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: const Icon(Icons.book, size: 30),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5, left: 8, right: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        borrowedBookInfo.bookName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        borrowedBookInfo.memberName,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: remainingDate < 0
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          remainingDate >= 0
                              ? '$remainingDate days left'
                              : 'Late',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// borrowed books listing sections
class BorrowedBooksListingSection extends StatefulWidget {
  final List<BorrowedBookClass> fliteredBorrowedBooks;
  const BorrowedBooksListingSection(
      {super.key, required this.fliteredBorrowedBooks});

  @override
  State<BorrowedBooksListingSection> createState() =>
      _BorrowedBooksListingSectionState();
}

class _BorrowedBooksListingSectionState
    extends State<BorrowedBooksListingSection> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.fliteredBorrowedBooks.length,
      itemBuilder: (context, index) {
        final borrowedBookData = widget.fliteredBorrowedBooks[index];
        final remainingDate =
            BorrowedBookUtils.borrowedBookRemainingDateCalculate(
                context, borrowedBookData);

        return Card(
          color: Theme.of(context).cardTheme.color,
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            onTap: () {
              borrowedBooksProfileBottomSheet(context, borrowedBookData, index);
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            leading: const CircleAvatar(child: Icon(Icons.book, color: Colors.white,)),
            title: Text(
              borrowedBookData.bookName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  borrowedBookData.memberName,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 5),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: remainingDate < 0
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    remainingDate >= 0 ? '$remainingDate days left' : 'Late',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            trailing: BorrowedBookOptionsMenu(
              remainDays: remainingDate,
              borrowedBookData: borrowedBookData,
              index: index,
              borrowedBookBox: Hive.box<BorrowedBookClass>('borrowedBooks'),
            ),
          ),
        );
      },
    );
  }
}
