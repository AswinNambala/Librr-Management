import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:librrr_management/models/books/books%20_class.dart';
import 'package:librrr_management/screens/books/widgets/book_list_section.dart';
import 'package:librrr_management/controllers/common%20functions/books_utils.dart';
import 'package:librrr_management/widgets/about_test_style.dart';
import 'package:librrr_management/widgets/appbar_for_all.dart';
import 'package:librrr_management/widgets/bottom_nav_bar.dart';
import 'package:librrr_management/screens/dash%20board/src_home_page.dart';
import 'package:librrr_management/widgets/search_text_form_field.dart';

class ListOfBooks extends StatefulWidget {
  const ListOfBooks({super.key});

  @override
  State<ListOfBooks> createState() => _ListOfBooksState();
}

class _ListOfBooksState extends State<ListOfBooks> {
  final TextEditingController searchText = TextEditingController();
  final box = Hive.box<BooksClass>('booksDetials');

  bool isGridView = true;
  List<BooksClass> allBooks = [];
  List<BooksClass> fliteredBooks = [];
  String bookNo = '';
  String? selectedFilterLanguage;
  String? selectedFilterGenre;
  @override
  void initState() {
    super.initState();
    allBooks = box.values.toList();
    fliteredBooks = allBooks;
    searchText.addListener(applyAllFilters);
    applyAllFilters();
    bookNo = fliteredBooks.length.toString();
  }

  void applyAllFilters() {
    final query = searchText.text.toLowerCase();
    setState(() {
      fliteredBooks = allBooks.where((book) {
        final matchesSearch = book.booksName.toLowerCase().contains(query) ||
            book.bookShelf.toLowerCase().contains(query);

        final matchesLanguage = selectedFilterLanguage == null ||
            book.language == selectedFilterLanguage;

        final matchesGenre = selectedFilterGenre == null ||
            book.booksGenre == selectedFilterGenre;

        return matchesSearch && matchesLanguage && matchesGenre;
      }).toList();

      bookNo = fliteredBooks.length.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarForAll(
        appBarTitle: 'Lists of Books',
        navToBorrow: false,
      ),
      bottomNavigationBar: BottomNavBar(
          currentIndex: 1,
          onTap: (index) {
            clearNavigateToHome(const DashboardScreen(), context);
          }),
      body: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.surface
            ])),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Library Books',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "$bookNo books available",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black),
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
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SearchTextFormField(
              hintText: 'Search books, Id....',
                searchString: searchText,
                suffixicons: Icons.filter_list_alt,
                suffixOnPress: () async {
                  final result = await BooksUtils.fliterBookByGenre(context);
                  if (result != null) {
                    setState(() {
                      selectedFilterLanguage = result['language'];
                      selectedFilterGenre = result['genre'];
                    });
                    applyAllFilters();
                  }
                }),
            const SizedBox(
              height: 15,
            ),
            const BooksListNavSection(),
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
                    valueListenable: box.listenable(),
                    builder: (context, Box<BooksClass> bookList, _) {
                      if (fliteredBooks.isEmpty) {
                        return const Center(
                          child: Text('No Books available'),
                        );
                      }

                      return isGridView
                          ? GridView.builder(
                              padding: const EdgeInsets.all(12),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                childAspectRatio: 0.65,
                              ),
                              itemCount: fliteredBooks.length,
                              itemBuilder: (context, index) {
                                final bookData = fliteredBooks[index];
                                return booksBuildGridViewBuilder(
                                    context, bookData, index);
                              },
                            )
                          : BooksListingSection(
                              fliteredBooks: fliteredBooks,
                            );
                    });
              }),
            )
          ],
        ),
      ),
    );
  }
}
