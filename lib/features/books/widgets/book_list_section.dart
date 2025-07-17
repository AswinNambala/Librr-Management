import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:librrr_management/data/models/books/books%20_class.dart';
import 'package:librrr_management/features/books/pages/src_book_profile.dart';
import 'package:librrr_management/features/books/pages/src_edit_book.dart';
import 'package:librrr_management/features/borrowed%20books/pages/src_borrowed_lists.dart';
import 'package:librrr_management/features/members/pages/src_member_list.dart';
import 'package:librrr_management/features/request%20book/pages/src_list_of_request_book.dart';
import 'package:librrr_management/core/helpers/about_test_style.dart';
import 'package:librrr_management/core/helpers/menu_options.dart';

class BooksListNavSection extends StatelessWidget {
  const BooksListNavSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.white))),
                    onPressed: () {
                      navigateTo(const ListOfRequestBook(), context);
                    },
                    child: Text(
                      'Requested Books',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.white))),
                    onPressed: () {
                      navigateTo(const BorrowedBooksList(), context);
                    },
                    child: Text(
                      'Borrowed Books',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.white))),
                    onPressed: () {
                      navigateTo(const MemberList(), context);
                    },
                    child: Text(
                      'Members List',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// list of books listing sections
class BooksListingSection extends StatefulWidget {
  final List<BooksClass> fliteredBooks;
  const BooksListingSection({super.key, required this.fliteredBooks});

  @override
  State<BooksListingSection> createState() => _BooksListingSectionState();
}

class _BooksListingSectionState extends State<BooksListingSection> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.fliteredBooks.length,
        itemBuilder: (context, index) {
          final bookData = widget.fliteredBooks[index];
          return Card(
            color: Theme.of(context).cardTheme.color,
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              onTap: () {
                navigateTo(
                    BooksProfileScreen(
                      bookInfo: bookData,
                      index: index,
                    ),
                    context);
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: bookData.imageBook == null
                      ? const Icon(Icons.person)
                      : Image.memory(
                          bookData.imageBook!,
                          fit: BoxFit.cover,
                          height: 40,
                          width: 40,
                        ),
                ),
              ),
              title: Text(
                bookData.booksName,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'by ${bookData.authorName}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10)),
                        child: bookData.numberOfBooks != '0'
                            ? Text(
                                'Available',
                                style: Theme.of(context).textTheme.titleSmall,
                              )
                            : Text(
                                'Out of Stock',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                    ],
                  )
                ],
              ),
              trailing: BookOptionsMenu(
                  bookData: bookData,
                  index: index,
                  bookBox: Hive.box<BooksClass>('booksDetials')),
            ),
          );
        });
  }
}

// list of books girdview design 
Widget booksBuildGridViewBuilder(
      BuildContext context, BooksClass bookInfo, int index) {
    return InkWell(
      onTap: () {
        navigateTo(
            BooksProfileScreen(
              bookInfo: bookInfo,
              index: index,
            ),
            context);
      },
      child: Container(
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
                  borderRadius:const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                child: bookInfo.imageBook == null
                    ? const Icon(Icons.person, size: 30)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          bookInfo.imageBook!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 5, left: 8, right: 8, top: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bookInfo.booksName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(bookInfo.authorName,
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10)),
                              child: bookInfo.numberOfBooks != '0'
                                  ? Text(
                                      'Available',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    )
                                  : Text(
                                      'Out of Stock',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                navigateTo(
                                    EditBooks(
                                        editBookInfo: bookInfo, index: index),
                                    context);
                              },
                              child: const Icon(
                                Icons.edit,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
