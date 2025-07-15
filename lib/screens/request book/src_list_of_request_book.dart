import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:librrr_management/models/requested_books/request_book_class.dart';
import 'package:librrr_management/screens/dash%20board/src_home_page.dart';
import 'package:librrr_management/screens/request%20book/widgets/requested_books_list.dart';
import 'package:librrr_management/widgets/about_test_style.dart';
import 'package:librrr_management/widgets/appbar_for_all.dart';
import 'package:librrr_management/widgets/bottom_nav_bar.dart';
import 'package:librrr_management/widgets/search_text_form_field.dart';

class ListOfRequestBook extends StatefulWidget {
  const ListOfRequestBook({super.key});

  @override
  State<ListOfRequestBook> createState() => _ListOfRequestBookState();
}

class _ListOfRequestBookState extends State<ListOfRequestBook> {
  final TextEditingController searchText = TextEditingController();
  bool isGridView = true;
  String bookNo = '';
  final box = Hive.box<RequestBookClass>('requestedBooks');
  List<RequestBookClass> rBooks = [];
  List<RequestBookClass> fliteredRequestedBooks = [];
  @override
  void initState() {
    super.initState();
    rBooks = box.values.toList();
    fliteredRequestedBooks = rBooks;
    searchText.addListener(onSearchFunctions);
    bookNo = fliteredRequestedBooks.length.toString();
  }

  void onSearchFunctions() {
    final query = searchText.text.toLowerCase();
    setState(() {
      fliteredRequestedBooks = rBooks.where((books) {
        final name = books.rBookName.toLowerCase();
        final authorsName = books.rAuthorName.toLowerCase();
        return name.contains(query) || authorsName.contains(query);
      }).toList();
    });
    bookNo = fliteredRequestedBooks.length.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const AppBarForAll(
        appBarTitle: 'List of Request Book',
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
                      'Library Requested Books',
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
            SearchTextFormField(searchString: searchText, hintText: 'Search books, authors name....',),
            const SizedBox(
              height: 15,
            ),
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
                        Hive.box<RequestBookClass>('requestedBooks').listenable(),
                    builder: (context, Box<RequestBookClass> bookInfo, _) {
                      rBooks = bookInfo.values.toList();
                      fliteredRequestedBooks = rBooks.where((rBooksInfo) {
                        final query = searchText.text.toLowerCase();
                        final name = rBooksInfo.rBookName.toLowerCase();
                        final authorsName = rBooksInfo.rAuthorName.toLowerCase();
                        return name.contains(query) ||
                            authorsName.contains(query);
                      }).toList();
                      if (fliteredRequestedBooks.isEmpty) {
                        return const Center(
                          child: Text('No Requested Books'),
                        );
                      }
                      return isGridView
                          ? GridView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(12),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                childAspectRatio: 0.75,
                              ),
                              itemCount: fliteredRequestedBooks.length,
                              itemBuilder: (context, index) {
                                final bookData = fliteredRequestedBooks[index];
                                return requestedBooksBuildGridViewBuilder(
                                    context, bookData, index);
                              },
                            )
                          : RequestedBooksListingSection(fliteredRequestedBooks: fliteredRequestedBooks,);
                    });
              }),
            )
          ],
        ),
      ),
    );
  }
}
