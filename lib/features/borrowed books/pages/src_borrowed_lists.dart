import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/features/borrowed%20books/widgets/list_borrowed_books.dart';
import 'package:librrr_management/features/dash%20board/pages/src_home_page.dart';
import 'package:librrr_management/core/helpers/about_test_style.dart';
import 'package:librrr_management/core/helpers/appbar_for_all.dart';
import 'package:librrr_management/core/helpers/bottom_nav_bar.dart';
import 'package:librrr_management/core/helpers/search_text_form_field.dart';

class BorrowedBooksList extends StatefulWidget {
  const BorrowedBooksList({super.key});

  @override
  State<BorrowedBooksList> createState() => _BorrowedBooksListState();
}

class _BorrowedBooksListState extends State<BorrowedBooksList> {
  final TextEditingController searchText = TextEditingController();
  bool isGridView = true;
  String borrowedBookNo = '';
  List<BorrowedBookClass> allBorrowedBooks = [];
  List<BorrowedBookClass> fliteredBorrowedBooks = [];

  @override
  void initState() {
    super.initState();
    final box = Hive.box<BorrowedBookClass>('borrowedBooks');
    allBorrowedBooks = box.values.toList();
    fliteredBorrowedBooks = allBorrowedBooks;
    searchText.addListener(onsearchFunction);
    borrowedBookNo = allBorrowedBooks.length.toString();
  }

  void onsearchFunction() {
    final query = searchText.text.toLowerCase();
    setState(() {
      fliteredBorrowedBooks = allBorrowedBooks.where((books) {
        final name = books.bookName.toLowerCase();
        final bookId = books.bookId;
        return name.contains(query) || bookId.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarForAll(
        appBarTitle: 'Borrowed Books Lists',
        navToBorrow: false,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          setState(() => index);
          clearNavigateToHome(const DashboardScreen(), context);
        },
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Library Borrowed Books',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$borrowedBookNo books available",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black,
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isGridView = !isGridView;
                      });
                    },
                    icon: Icon(
                      isGridView ? Icons.list : Icons.grid_view,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SearchTextFormField(searchString: searchText, hintText: 'Search books, Id...',),
            const SizedBox(height: 15),
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                int crossAxisCount = 2;
                double width = constraints.maxWidth;

                if (width > 1200) {
                  crossAxisCount = 5;
                } else if (width > 800) {
                  crossAxisCount = 4;
                } else if (width > 600) {
                  crossAxisCount = 3;
                }

                return ValueListenableBuilder(
                  valueListenable:
                      Hive.box<BorrowedBookClass>('borrowedBooks').listenable(),
                  builder:
                      (context, Box<BorrowedBookClass> borrowedBookList, _) {
                    allBorrowedBooks = borrowedBookList.values.toList();
                    fliteredBorrowedBooks =
                        allBorrowedBooks.where((borrowedBooks) {
                      final query = searchText.text.toLowerCase();
                      final name = borrowedBooks.bookName.toLowerCase();
                      final id = borrowedBooks.bookId;
                      return name.contains(query) || id.contains(query);
                    }).toList();

                    if (fliteredBorrowedBooks.isEmpty) {
                      return const Center(child: Text('No Books available'));
                    }

                    return isGridView
                        ? GridView.builder(
                            padding: const EdgeInsets.all(12),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              childAspectRatio: 0.60,
                            ),
                            itemCount: fliteredBorrowedBooks.length,
                            itemBuilder: (context, index) {
                              final borrowedBookData =
                                  fliteredBorrowedBooks[index];
                              return borrowedBuildGridViewBuilder(
                                  context, borrowedBookData, index);
                            },
                          )
                        : BorrowedBooksListingSection(
                            fliteredBorrowedBooks: fliteredBorrowedBooks,
                          );
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
