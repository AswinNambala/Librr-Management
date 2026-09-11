import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librrr_management/data/models/books/books%20_class.dart';
import 'package:librrr_management/features/books/providers/book_providers.dart';
import 'package:librrr_management/features/books/widgets/profile_history_section.dart';
import 'package:librrr_management/features/borrowed%20books/pages/src_add_borrowed_book.dart';
import 'package:librrr_management/core/helpers/about_test_style.dart';
import 'package:librrr_management/core/helpers/bottom_nav_bar.dart';
import 'package:librrr_management/features/dash%20board/pages/src_home_page.dart';
import 'package:librrr_management/core/helpers/menu_options.dart';

class BooksProfileScreen extends ConsumerStatefulWidget {
  final BooksClass bookInfo;
  final int index;
  const BooksProfileScreen(
      {required this.bookInfo, required this.index, super.key});

  @override
  ConsumerState<BooksProfileScreen> createState() => _BooksProfileScreenState();
}

class _BooksProfileScreenState extends ConsumerState<BooksProfileScreen>
    with TickerProviderStateMixin {
  late TabController tabBarController;

  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookHistory =
        ref.watch(bookHistoryProvider(widget.bookInfo.bookShelf));
    final booksBorrowed =
        ref.watch(borrowedBooksForBookProvider(widget.bookInfo.bookShelf));
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          clearNavigateToHome(const DashboardScreen(), context);
        },
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWeb = constraints.maxWidth > 600;
          return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                    colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  Theme.of(context).colorScheme.surface
                ])),
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back,
                                size: 30, color: Colors.white)),
                        BookPofileOptionsMenu(
                          bookData: widget.bookInfo,
                          index: widget.index,
                          booksInHand: booksBorrowed.asData?.value ?? const [],
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    BooksProfileSection(
                      bookInfo: widget.bookInfo,
                      isWeb: isWeb,
                      index: widget.index,
                      booksInHand: booksBorrowed.asData?.value ?? const [],
                    ),
                    const SizedBox(height: 30),
                    BooksProfileTabBar(tabControl: tabBarController),
                    Expanded(
                        child:
                            TabBarView(controller: tabBarController, children: [
                      ProfileHistorySection(
                          bookHistory: bookHistory.asData?.value ?? const []),
                      ProfileBorrowedSection(
                          borrowedMemebers:
                              booksBorrowed.asData?.value ?? const []),
                    ])),
                  ],
                ),
                if (widget.bookInfo.numberOfBooks != "0")
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        navigateTo(
                            AddBorrowedBooks(
                              bookName: widget.bookInfo.booksName,
                              bookId: widget.bookInfo.bookShelf,
                              bookLang: widget.bookInfo.language,
                            ),
                            context);
                      },
                      child: Container(
                        width: 140,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.4),
                                spreadRadius: 2,
                                blurRadius: 5,
                              )
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add,
                                size: 20, color: Colors.white),
                            Text('Borrow Book',
                                style: Theme.of(context).textTheme.bodyLarge)
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
