import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:librrr_management/data/models/books/books%20_class.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/data/models/members/members_class.dart';
import 'package:librrr_management/data/models/requested_books/request_book_class.dart';
import 'package:librrr_management/features/dash%20board/widgets/web_screen_section.dart';
import 'package:librrr_management/features/borrowed%20books/pages/src_borrowed_lists.dart';
import 'package:librrr_management/features/books/pages/src_list_of_books.dart';
import 'package:librrr_management/features/dash%20board/widgets/home_quick_function.dart';
import 'package:librrr_management/features/members/pages/src_membership_plan.dart';
import 'package:librrr_management/features/dash%20board/widgets/home_functions.dart';
import 'package:librrr_management/core/helpers/about_test_style.dart';

class WebDashboardScreen extends StatefulWidget {
  const WebDashboardScreen({super.key});

  @override
  State<WebDashboardScreen> createState() => _WebDashboardScreenState();
}

class _WebDashboardScreenState extends State<WebDashboardScreen> {
 

  int selectedIndex = 0;
  String? totalBook;
  String? memberCount;
  String? availableBook;
  String? requestedBook;

  @override
  void initState() {
    super.initState();
    log('entered inside web src');
    final bookBox = Hive.box<BooksClass>('booksDetials');
    final borrowedBox = Hive.box<BorrowedBookClass>('borrowedBooks');
    final memberBox = Hive.box<MemberClass>('members');
    final requestBox = Hive.box<RequestBookClass>('requestedBooks');
    final int borrowedBook = borrowedBox.length;
    requestedBook = requestBox.length.toString();
    final int bookLength = bookBox.values.fold(
      0,
      (sum, element) {
        return sum + int.parse(element.numberOfBooks);
      },
    );
    setState(() {
      totalBook = bookLength.toString();
      availableBook = borrowedBook == 0
          ? bookLength.toString()
          : (bookLength - borrowedBook).toString();
      memberCount = memberBox.length.toString();
    });
    log('init of web src is completed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: const WebAppbarSection(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 1000;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WebMenuSection(size: isWide? 240 : 180),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dashboard',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 25),
                      Wrap(
                        spacing: 25,
                        runSpacing: 25,
                        children: [
                          DashBoardContainer(
                              boxColor: Colors.pink,
                              icon: Icons.groups,
                              subHead: 'Total',
                              count: totalBook!),
                          DashBoardContainer(
                              boxColor: Theme.of(context).colorScheme.secondary,
                              icon: Icons.groups,
                              subHead: 'Members',
                              count: memberCount!),
                          DashBoardContainer(
                              boxColor: Colors.green,
                              icon: Icons.menu_book_rounded,
                              subHead: 'Available',
                              count: availableBook!),
                          DashBoardContainer(
                              boxColor: Colors.orange,
                              icon: Icons.book_sharp,
                              subHead: 'Requested \n Books',
                              count: requestedBook!),
                        ],
                      ),
                      const SizedBox(height: 50),
                      const Text(
                        'Quick Access',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 25,
                        runSpacing: 25,
                        children: [
                          QuickContainer(
                            boxColor: Colors.pink,
                            icon: Icons.chrome_reader_mode_outlined,
                            subHead: 'Membership Plan',
                            navigate: () =>
                                navigateTo(const MembershipPlan(), context),
                          ),
                          QuickContainer(
                            boxColor: Colors.blue,
                            icon: Icons.menu_book_sharp,
                            subHead: 'Books List',
                            navigate: () =>
                                navigateTo(const ListOfBooks(), context),
                          ),
                          QuickContainer(
                            boxColor: Colors.green,
                            icon: Icons.thumb_up_off_alt_rounded,
                            subHead: 'Borrowed Book List',
                            navigate: () =>
                                navigateTo(const BorrowedBooksList(), context),
                          ),
                          QuickContainer(
                            boxColor: Colors.orange,
                            icon: Icons.local_library_rounded,
                            subHead: 'Borrowed Books List',
                            navigate: () =>
                                navigateTo(const BorrowedBooksList(), context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
