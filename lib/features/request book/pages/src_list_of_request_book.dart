import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librrr_management/features/dash%20board/pages/src_home_page.dart';
import 'package:librrr_management/features/request%20book/provider/request_book_provider.dart';
import 'package:librrr_management/features/request%20book/widgets/requested_books_list.dart';
import 'package:librrr_management/core/helpers/about_test_style.dart';
import 'package:librrr_management/core/helpers/appbar_for_all.dart';
import 'package:librrr_management/core/helpers/bottom_nav_bar.dart';
import 'package:librrr_management/core/helpers/search_text_form_field.dart';

class ListOfRequestBook extends ConsumerStatefulWidget {
  const ListOfRequestBook({super.key});

  @override
  ConsumerState<ListOfRequestBook> createState() => _ListOfRequestBookState();
}

class _ListOfRequestBookState extends ConsumerState<ListOfRequestBook> {
  final TextEditingController searchText = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchText.addListener(() {
      ref.read(requestedSearchQueryProvider.notifier).state = searchText.text;
    });
  }

  @override
  void dispose() {
    searchText.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fliteredRequestedBooks = ref.watch(filteredRequestedBooksProvider);
    final isGridView = ref.watch(requestedGridViewProvider);
    final bookNo = fliteredRequestedBooks.length.toString();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const AppBarForAll(appBarTitle: 'List of Request Book', navToBorrow: false),
      bottomNavigationBar: BottomNavBar(
          currentIndex: 1,
          onTap: (index) => clearNavigateToHome(const DashboardScreen(), context)),
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
                    Text('Requested Books', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 4),
                    Text("$bookNo books available", style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.black),
                  child: IconButton(
                      onPressed: () {
                        ref.read(requestedGridViewProvider.notifier).state = !isGridView;
                      },
                      icon: Icon(isGridView ? Icons.list : Icons.grid_view, size: 30, color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SearchTextFormField(searchString: searchText, hintText: 'Search books, authors name....'),
            const SizedBox(height: 15),
            Expanded(
              child: fliteredRequestedBooks.isEmpty
                  ? const Center(child: Text('No Requested Books'))
                  : LayoutBuilder(builder: (context, constraints) {
                      int crossAxisCount = 2;
                      double width = constraints.maxWidth;
                      if (width > 1200) {
                        crossAxisCount = 5;
                      } else if (width > 800) {
                        crossAxisCount = 4;
                      } else if (width > 600) {
                        crossAxisCount = 3;
                      }

                      return isGridView
                          ? GridView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(12),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                childAspectRatio: 0.75,
                              ),
                              itemCount: fliteredRequestedBooks.length,
                              itemBuilder: (context, index) {
                                final bookData = fliteredRequestedBooks[index];
                                return requestedBooksBuildGridViewBuilder(context, bookData);
                              },
                            )
                          : RequestedBooksListingSection(fliteredRequestedBooks: fliteredRequestedBooks);
                    }),
            )
          ],
        ),
      ),
    );
  }
}