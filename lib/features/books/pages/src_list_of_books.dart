import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librrr_management/features/books/providers/book_providers.dart';
import 'package:librrr_management/features/books/widgets/book_add_section.dart';
import 'package:librrr_management/features/books/widgets/book_list_section.dart';
import 'package:librrr_management/core/helpers/about_test_style.dart';
import 'package:librrr_management/core/helpers/appbar_for_all.dart';
import 'package:librrr_management/core/helpers/bottom_nav_bar.dart';
import 'package:librrr_management/features/dash%20board/pages/src_home_page.dart';
import 'package:librrr_management/core/helpers/search_text_form_field.dart';

class ListOfBooks extends ConsumerStatefulWidget {
  const ListOfBooks({super.key});

  @override
  ConsumerState<ListOfBooks> createState() => _ListOfBooksState();
}

class _ListOfBooksState extends ConsumerState<ListOfBooks> {
  final TextEditingController searchText = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchText.addListener(() {
      ref.read(bookSearchQueryProvider.notifier).state = searchText.text;
    });
  }

  @override
  void dispose() {
    searchText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Always derived from the live Hive box via filteredBooksProvider —
    // no more stale snapshot taken once in initState.
    final fliteredBooks = ref.watch(filteredBooksProvider);
    final isGridView = ref.watch(bookGridViewProvider);
    final bookNo = fliteredBooks.length.toString();

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
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
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
                    const SizedBox(height: 4),
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
                        ref.read(bookGridViewProvider.notifier).state =
                            !isGridView;
                      },
                      icon: Icon(
                        isGridView ? Icons.list : Icons.grid_view,
                        size: 30,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SearchTextFormField(
                hintText: 'Search books, Id....',
                searchString: searchText,
                suffixicons: Icons.filter_list_alt,
                suffixOnPress: () => fliterBookByGenre(context, ref)),
            const SizedBox(height: 15),
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

                if (fliteredBooks.isEmpty) {
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
                          childAspectRatio: 0.65,
                        ),
                        itemCount: fliteredBooks.length,
                        itemBuilder: (context, index) {
                          final bookData = fliteredBooks[index];
                          return booksBuildGridViewBuilder(
                              context, bookData, index);
                        },
                      )
                    : BooksListingSection(fliteredBooks: fliteredBooks);
              }),
            )
          ],
        ),
      ),
    );
  }
}