import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:librrr_management/features/books/controllers/books_utils.dart';
import 'package:librrr_management/data/models/books/books%20_class.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/data/models/finished_books/finished_book_class.dart';
import 'package:librrr_management/core/helpers/menu_options.dart';

// books profile tab view for showing history of books
class BooksProfileTabBar extends StatelessWidget {
  final TabController tabControl;
  const BooksProfileTabBar({super.key, required this.tabControl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10)),
      child: TabBar(
          controller: tabControl,
          indicator: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(10)),
          unselectedLabelColor: Theme.of(context).colorScheme.surface,
          labelColor: Colors.white,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.library_books_outlined,
                    size: 15,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'History',
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.bookmark,
                    size: 15,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Borrowed',
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                ],
              ),
            ),
          ]),
    );
  }
}

// book profile page books history of members
class ProfileHistorySection extends StatefulWidget {
  final List<FinishedBookClass> bookHistory;
  const ProfileHistorySection({super.key, required this.bookHistory});

  @override
  State<ProfileHistorySection> createState() => _ProfileHistorySectionState();
}

class _ProfileHistorySectionState extends State<ProfileHistorySection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onTertiary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.bookHistory.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.book,
                        color: Colors.white,
                        size: 40,
                      ),
                      Text(
                        'No Member',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Not any members have read this book',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: widget.bookHistory.length,
                    itemBuilder: (context, index) {
                      final bMember = widget.bookHistory[index];
                      return InkWell(
                        onTap: () {
                          BooksUtils.booksOpenMembersProfile(
                              bMember.memberId, context);
                        },
                        child: Card(
                          color: Theme.of(context).colorScheme.surface,
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            leading: const CircleAvatar(
                              child: Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              bMember.memberName,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            subtitle: Text(
                              bMember.memberId,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            trailing: Text(
                              bMember.bookReturnedDate,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

// books profile page tab view borrowed members
class ProfileBorrowedSection extends StatefulWidget {
  final List<BorrowedBookClass> borrowedMemebers;
  const ProfileBorrowedSection({super.key, required this.borrowedMemebers});

  @override
  State<ProfileBorrowedSection> createState() => _ProfileBorrowedSectionState();
}

class _ProfileBorrowedSectionState extends State<ProfileBorrowedSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onTertiary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.borrowedMemebers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.book,
                        color: Colors.white,
                        size: 40,
                      ),
                      Text(
                        'No Member Borrowed',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Not any members borrowed this book',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: widget.borrowedMemebers.length,
                    itemBuilder: (context, index) {
                      final bMember = widget.borrowedMemebers[index];
                      return InkWell(
                        onTap: () {
                          BooksUtils.booksOpenMembersProfile(
                              bMember.memberId, context);
                        },
                        child: Card(
                          color: Theme.of(context).colorScheme.surface,
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            leading: const CircleAvatar(
                              child: Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              bMember.memberName,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            subtitle: Text(
                              bMember.memberId,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            trailing: Text(
                              bMember.borrowedDate,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

// book profile page book profile section
class BooksProfileSection extends StatefulWidget {
  final BooksClass bookInfo;
  final int index;
  final bool isWeb;
  final List<BorrowedBookClass> booksInHand;
  const BooksProfileSection(
      {super.key,
      required this.bookInfo,
      required this.isWeb,
      required this.booksInHand,
      required this.index});

  @override
  State<BooksProfileSection> createState() => _BooksProfileSectionState();
}

class _BooksProfileSectionState extends State<BooksProfileSection> {
  int booksStock = 0;
  @override
  void initState() {
    super.initState();
    booksStock = int.parse(widget.bookInfo.numberOfBooks);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: widget.isWeb ? 200 : 110,
          width: widget.isWeb ? 200 : 110,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                )
              ],
              shape: BoxShape.circle),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(80),
            child: widget.bookInfo.imageBook != null
                ? Image.memory(
                    widget.bookInfo.imageBook!,
                    fit: BoxFit.cover,
                  )
                : Icon(
                    Icons.book,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    size: 35,
                  ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.bookInfo.booksName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.bookInfo.authorName,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              widget.bookInfo.bookShelf,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Container(
                  width: widget.isWeb ? 150 : 100,
                  height: widget.isWeb ? 40 : 25,
                  decoration: BoxDecoration(
                    color: booksStock >= 1? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                     booksStock >= 1
                          ? 'Available'
                          : 'No Stock',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                SizedBox(
                  width: widget.isWeb ? 30 : 15,
                ),
                InkWell(
                  onTap: () {
                    booksProfileBottomSheet(context, widget.bookInfo,
                        widget.index, widget.booksInHand);
                  },
                  child: Container(
                    width: widget.isWeb ? 150 : 110,
                    height: widget.isWeb ? 40 : 28,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onTertiary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                        child: Text(
                      'View Details',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )),
                  ),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}

// bottom sheet for book profile to view profile book full detials
void booksProfileBottomSheet(BuildContext context, BooksClass books,
    int keyIndex, List<BorrowedBookClass> booksInHand) {
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
              'Book Details',
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                      )
                    ],
                  ),
                  child: books.imageBook == null
                      ? const Icon(
                          Icons.menu_book,
                          size: 40,
                          color: Colors.grey,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(books.imageBook!,
                              fit: BoxFit.cover)),
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
                            books.booksName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          BookPofileOptionsMenu(
                            bookData: books,
                            index: keyIndex,
                            bookBox: Hive.box<BooksClass>('booksDetials'),
                            booksInHand: booksInHand,
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        books.bookShelf,
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
              title: Text(
                "Language",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Text(
                books.language,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Authors Name",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Text(
                books.authorName,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Genre",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Text(
                books.booksGenre,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Available Books",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Text(
                '${books.numberOfBooks} books',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Book Price",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Text(
                '₹ ${books.booksPrice}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      );
    },
  );
}
