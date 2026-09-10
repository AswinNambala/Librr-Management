import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librrr_management/data/models/books/books%20_class.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/data/models/members/members_class.dart';
import 'package:librrr_management/features/books/pages/src_edit_book.dart';
import 'package:librrr_management/features/books/pages/src_book_profile.dart';
import 'package:librrr_management/features/books/providers/book_providers.dart';
import 'package:librrr_management/features/borrowed%20books/providers/borrowed_book_providers.dart';
import 'package:librrr_management/features/late_entry/page/src_late_entry_book.dart';
import 'package:librrr_management/features/members/pages/src_edit_members.dart';
import 'package:librrr_management/features/members/pages/src_member_profile.dart';
import 'package:librrr_management/features/members/providers/member_providers.dart';
import 'package:librrr_management/core/helpers/about_test_style.dart';
import 'package:librrr_management/core/helpers/snackbar_for_all.dart';

// this popup menu is only for book class models
class BookOptionsMenu extends ConsumerWidget {
  final BooksClass bookData;
  final int index;

  const BookOptionsMenu({
    super.key,
    required this.bookData,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      iconColor: Colors.white,
      onSelected: (value) async {
        if (value == 'Open') {
          navigateTo(BooksProfileScreen(bookInfo: bookData, index: index), context);
        } else if (value == 'Edit') {
          navigateTo(EditBooks(editBookInfo: bookData), context);
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'Open', child: Text('Open', style: TextStyle(color: Colors.white))),
        PopupMenuItem(value: 'Edit', child: Text('Edit', style: TextStyle(color: Colors.white))),
      ],
    );
  }
}

// this popup menu is only for book profile class models
class BookPofileOptionsMenu extends ConsumerWidget {
  final BooksClass bookData;
  final int index;
  final List<BorrowedBookClass> booksInHand;

  const BookPofileOptionsMenu({
    super.key,
    required this.bookData,
    required this.index,
    required this.booksInHand,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      iconColor: Colors.white,
      onSelected: (value) async {
        if (value == 'Edit') {
          navigateTo(EditBooks(editBookInfo: bookData), context);
        } else if (value == 'Delete') {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirm Delete'),
              content: const Text('Are you sure you want to delete?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );

          if (confirm != true) return;
          if (!context.mounted) return;

          if (booksInHand.isEmpty) {
            await ref.read(booksListProvider.notifier).deleteBook(bookData);
            if (!context.mounted) return;
            Navigator.pop(context);
            SnackBarForAll.showSuccess(context, 'book has been deleted.');
          } else {
            errorForBooksInHands(context);
          }
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'Edit', child: Text('Edit', style: TextStyle(color: Colors.white))),
        PopupMenuItem(value: 'Delete', child: Text('Delete', style: TextStyle(color: Colors.white))),
      ],
    );
  }
}

// this popup menu is only for borrowed book class models
class BorrowedBookOptionsMenu extends ConsumerStatefulWidget {
  final BorrowedBookClass borrowedBookData;
  final int index;
  final int remainDays;
  final bool closeParentSheetOnReturn;

  const BorrowedBookOptionsMenu({
    super.key,
    required this.borrowedBookData,
    required this.index,
    required this.remainDays,
    this.closeParentSheetOnReturn = false,
  });

  @override
  ConsumerState<BorrowedBookOptionsMenu> createState() => _BorrowedBookOptionsMenuState();
}

class _BorrowedBookOptionsMenuState extends ConsumerState<BorrowedBookOptionsMenu> {
  late int daysBalance;

  @override
  void initState() {
    super.initState();
    daysBalance = widget.remainDays;
  }

  @override
  void didUpdateWidget(covariant BorrowedBookOptionsMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.remainDays != widget.remainDays) {
      daysBalance = widget.remainDays;
    }
  }

  Future<void> _onBookReturned() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Return'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Returned', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    final finishedRepo = ref.read(finishedBooksRepositoryProvider);
    await ref.read(borrowedBooksListProvider.notifier).markBookReturned(widget.borrowedBookData, finishedRepo);

    if (!mounted) return;
    if (widget.closeParentSheetOnReturn) Navigator.pop(context);

    if (!mounted) return;
    SnackBarForAll.showSuccess(context, 'book has been Returned.');
  }

  @override
  Widget build(BuildContext context) {
    final bool isLate = daysBalance <= 0;
    return PopupMenuButton<String>(
      iconColor: Colors.white,
      onSelected: (value) async {
        if (value == 'Late Return') {
          navigateTo(LateEntryBooks(borrowedBookDetails: widget.borrowedBookData), context);
        } else if (value == 'Book Returned') {
          await _onBookReturned();
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'Open', child: Text('Open', style: TextStyle(color: Colors.white))),
        if (isLate)
          const PopupMenuItem(value: 'Late Return', child: Text('Late Return', style: TextStyle(color: Colors.white))),
        if (!isLate)
          const PopupMenuItem(value: 'Book Returned', child: Text('Book Returned', style: TextStyle(color: Colors.white))),
      ],
    );
  }
}

// this popup menu is only for members class models
class MemberOptionsMenus extends StatelessWidget {
  final MemberClass account;
  final int index;

  const MemberOptionsMenus({super.key, required this.account, required this.index});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      iconColor: Colors.white,
      onSelected: (value) async {
        if (value == 'Open') {
          navigateTo(MemebersProfileScreen(memberDetails: account, membersKey: index), context);
        } else if (value == 'Edit') {
          navigateTo(EditMemberScreen(memberEditDetails: account), context);
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'Open', child: Text('Open', style: TextStyle(color: Colors.white))),
        PopupMenuItem(value: 'Edit', child: Text('Edit', style: TextStyle(color: Colors.white))),
      ],
    );
  }
}

// this popup menu is only for members profile page
class MemberProfileOptionMenu extends ConsumerWidget {
  final MemberClass account;
  final int index;
  final List<BorrowedBookClass> booksInHand;

  const MemberProfileOptionMenu({
    super.key,
    required this.account,
    required this.index,
    required this.booksInHand,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      iconColor: Colors.white,
      onSelected: (value) async {
        if (value == 'Edit') {
          navigateTo(EditMemberScreen(memberEditDetails: account), context);
        } else if (value == 'Delete') {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirm Delete'),
              content: Text('Are you sure you want to delete ${account.mFirstName}?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );

          if (confirm != true) return;
          if (!context.mounted) return;

          if (booksInHand.isEmpty) {
            await ref.read(membersListProvider.notifier).deleteMember(account);
            if (!context.mounted) return;
            SnackBarForAll.showSuccess(context, '${account.mFirstName} has been deleted.');
          } else {
            errorForBooksInHands(context);
          }
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'Edit', child: Text('Edit', style: TextStyle(color: Colors.white))),
        PopupMenuItem(value: 'Delete', child: Text('Delete', style: TextStyle(color: Colors.white))),
      ],
    );
  }
}

Future<void> errorForBooksInHands(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Alert', style: Theme.of(context).textTheme.titleLarge),
            content: Text(
              'You haven\'t returned borrowed books',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Ok', style: Theme.of(context).textTheme.bodyMedium))
            ],
          ));
}