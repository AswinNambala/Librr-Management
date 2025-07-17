import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:librrr_management/data/models/books/books%20_class.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/data/models/finished_books/finished_book_class.dart';
import 'package:librrr_management/data/models/members/members_class.dart';
import 'package:librrr_management/features/books/pages/src_edit_book.dart';
import 'package:librrr_management/features/late_entry/page/src_late_entry_book.dart';
import 'package:librrr_management/features/books/pages/src_list_of_books.dart';
import 'package:librrr_management/features/members/pages/src_edit_members.dart';
import 'package:librrr_management/features/members/pages/src_member_profile.dart';
import 'package:librrr_management/core/helpers/about_test_style.dart';
import 'package:librrr_management/core/helpers/snackbar_for_all.dart';

// this popup menu is only for book class models
class BookOptionsMenu extends StatelessWidget {
  final BooksClass bookData;
  final int index;
  final Box<BooksClass> bookBox;

  const BookOptionsMenu({
    super.key,
    required this.bookData,
    required this.index,
    required this.bookBox,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      iconColor: Colors.white,
      onSelected: (value) async {
        if (value == 'Open') {
          navigateTo(const ListOfBooks(), context);
        } else if (value == 'Edit') {
          navigateTo(
              EditBooks(
                editBookInfo: bookData,
                index: index,
              ),
              context);
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'Open',
          child: Text(
            'Open',
            style: TextStyle(color: Colors.white),
          ),
        ),
        PopupMenuItem(
          value: 'Edit',
          child: Text(
            'Edit',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

// this popup menu is only for book profile class models
class BookPofileOptionsMenu extends StatelessWidget {
  final BooksClass bookData;
  final int index;
  final Box<BooksClass> bookBox;
  final List<BorrowedBookClass> booksInHand;

  const BookPofileOptionsMenu(
      {super.key,
      required this.bookData,
      required this.index,
      required this.bookBox,
      required this.booksInHand});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      iconColor: Colors.white,
      onSelected: (value) async {
        if (value == 'Edit') {
          navigateTo(
              EditBooks(
                editBookInfo: bookData,
                index: index,
              ),
              context);
        } else if (value == 'Delete') {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirm Delete'),
              content: const Text(
                'Are you sure you want to delete?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );

          if (confirm == true) {
            if (booksInHand.isEmpty) {
              await bookBox.deleteAt(index);
              Navigator.pop(context);
              SnackBarForAll.showSuccess(
                context,
                'book has been deleted.',
              );
            } else {
              errorForBooksInHands(context);
            }
          }
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'Edit',
          child: Text(
            'Edit',
            style: TextStyle(color: Colors.white),
          ),
        ),
        PopupMenuItem(
          value: 'Delete',
          child: Text(
            'Delete',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

// this popup menu is only for borrowed book class models
class BorrowedBookOptionsMenu extends StatefulWidget {
  final BorrowedBookClass borrowedBookData;
  final int index;
  final Box<BorrowedBookClass> borrowedBookBox;
  final int remainDays;

  const BorrowedBookOptionsMenu(
      {super.key,
      required this.borrowedBookData,
      required this.index,
      required this.borrowedBookBox,
      required this.remainDays});

  @override
  State<BorrowedBookOptionsMenu> createState() =>
      _BorrowedBookOptionsMenuState();
}

class _BorrowedBookOptionsMenuState extends State<BorrowedBookOptionsMenu> {
  int? daysBalance;
  @override
  void initState() {
    super.initState();
    daysBalance = widget.remainDays;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      iconColor: Colors.white,
      onSelected: (value) async {
        if (value == 'Late Return') {
          navigateTo(
              LateEntryBooks(
                borrowedBookDetails: widget.borrowedBookData,
                index: widget.index,
              ),
              context);
        } else if (value == 'Book Returned') {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirm Return'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    'Returned',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );

          if (confirm == true) {
            debugPrint('adding loading....');
            final finishedBook = Hive.box<FinishedBookClass>('finishedBooks');
            final booksData = FinishedBookClass(
                widget.borrowedBookData.bookName,
                widget.borrowedBookData.bookId,
                widget.borrowedBookData.memberId,
                widget.borrowedBookData.memberName,
                '',
                widget.borrowedBookData.returnDate);
            finishedBook.add(booksData);
            await widget.borrowedBookBox.deleteAt(widget.index);
            Navigator.pop(context);
            SnackBarForAll.showSuccess(
              context,
              'book has been Returned.',
            );
            final bookBox = Hive.box<BooksClass>('booksDetials');
            final bookIndex = bookBox.values.toList().indexWhere(
                  (b) => b.bookShelf == widget.borrowedBookData.bookId,
                );

            if (bookIndex != -1) {
              final book = bookBox.getAt(bookIndex)!;
              book.numberOfBooks =
                  (int.parse(book.numberOfBooks) + 1).toString();
              await bookBox.putAt(bookIndex, book);
            }
          }
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'Open',
          child: Text(
            'Open',
            style: TextStyle(color: Colors.white),
          ),
        ),
        if (daysBalance! <= 1)
          const PopupMenuItem(
            value: 'Late Return',
            child: Text(
              'Late Return',
              style: TextStyle(color: Colors.white),
            ),
          ),
        if (daysBalance! >= 1)
          const PopupMenuItem(
            value: 'Book Returned',
            child: Text(
              'Book Returned',
              style: TextStyle(color: Colors.white),
            ),
          ),
      ],
    );
  }
}

// this popup menu is only for members class models
class MemberOptionsMenus extends StatelessWidget {
  final MemberClass account;
  final int index;
  final Box<MemberClass> box;

  const MemberOptionsMenus({
    super.key,
    required this.account,
    required this.index,
    required this.box,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      iconColor: Colors.white,
      onSelected: (value) async {
        if (value == 'Open') {
          navigateTo(
            MemebersProfileScreen(
              memberDetails: account,
              membersKey: index,
            ),
            context,
          );
        } else if (value == 'Edit') {
          navigateTo(
            EditMemberScreen(
              memberEditDetails: account,
              index: index,
            ),
            context,
          );
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'Open',
          child: Text(
            'Open',
            style: TextStyle(color: Colors.white),
          ),
        ),
        PopupMenuItem(
          value: 'Edit',
          child: Text(
            'Edit',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

// this popup menu is only for members profile page
class MemberProfileOptionMenu extends StatelessWidget {
  final MemberClass account;
  final int index;
  final Box<MemberClass> box;
  final List<BorrowedBookClass> booksInHand;
  const MemberProfileOptionMenu(
      {super.key,
      required this.account,
      required this.index,
      required this.box,
      required this.booksInHand});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      iconColor: Colors.white,
      onSelected: (value) async {
        if (value == 'Edit') {
          navigateTo(
            EditMemberScreen(
              memberEditDetails: account,
              index: index,
            ),
            context,
          );
        } else if (value == 'Delete') {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirm Delete'),
              content: Text(
                'Are you sure you want to delete ${account.mFirstName}?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );

          if (confirm == true) {
            if (booksInHand.isEmpty) {
              await box.deleteAt(index);
              SnackBarForAll.showSuccess(
                context,
                '${account.mFirstName} has been deleted.',
              );
            } else {
              errorForBooksInHands(context);
            }
          }
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'Edit',
          child: Text(
            'Edit',
            style: TextStyle(color: Colors.white),
          ),
        ),
        PopupMenuItem(
          value: 'Delete',
          child: Text(
            'Delete',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

Future<void> errorForBooksInHands(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              'Alert',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            content: Text(
              'You haven\'t returned borrowed books',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Ok',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ))
            ],
          ));
}
