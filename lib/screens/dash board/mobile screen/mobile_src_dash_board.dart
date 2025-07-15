import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:librrr_management/controllers/common%20functions/notifications_utils.dart';
import 'package:librrr_management/models/books/books%20_class.dart';
import 'package:librrr_management/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/models/members/members_class.dart';
import 'package:librrr_management/models/notifications/notification_class.dart';
import 'package:librrr_management/models/requested_books/request_book_class.dart';
import 'package:librrr_management/screens/dash%20board/widgets/moblie_screens.dart';
import 'package:librrr_management/screens/notifications/src_notification_list.dart';
import 'package:librrr_management/screens/request%20book/src_request_book.dart';
import 'package:librrr_management/widgets/about_test_style.dart';
import 'package:librrr_management/widgets/bottom_nav_bar.dart';
import 'package:librrr_management/screens/borrowed%20books/src_borrowed_lists.dart';
import 'package:librrr_management/screens/books/src_list_of_books.dart';
import 'package:librrr_management/screens/dash%20board/widgets/home_quick_function.dart';
import 'package:librrr_management/screens/dash%20board/src_home_page.dart';
import 'package:librrr_management/screens/members/src_membership_plan.dart';
import 'package:librrr_management/screens/dash%20board/widgets/home_functions.dart';

class MobileHomeScreen extends StatefulWidget {
  const MobileHomeScreen({super.key});

  @override
  State<MobileHomeScreen> createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<MobileHomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 1;
  String? totalBook;
  String? memberCount;
  String? availableBook;
  String? requestBook;
  final notiBox = Hive.box<NotificationClass>('notifications');

  @override
  void initState() {
    super.initState();
    loadValues();
    Hive.box<BooksClass>('booksDetials').listenable().addListener(loadValues);
    Hive.box<BorrowedBookClass>('borrowedBooks')
        .listenable()
        .addListener(loadValues);
    Hive.box<MemberClass>('members').listenable().addListener(loadValues);
    Hive.box<RequestBookClass>('requestedBooks')
        .listenable()
        .addListener(loadValues);
    initializeNotifications().then((_) async {
      await NotificationsUtils.checkLateReturnsAndExpiredMemberships();
    });
  }

  void loadValues() {
    final bookBox = Hive.box<BooksClass>('booksDetials');
    final borrowedBox = Hive.box<BorrowedBookClass>('borrowedBooks');
    final memberBox = Hive.box<MemberClass>('members');
    final requestBox = Hive.box<RequestBookClass>('requestedBooks');
    final int borrowedBook = borrowedBox.length;
    requestBook = requestBox.length.toString();
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
          : (bookLength - borrowedBook).abs().toString();
      memberCount = memberBox.length.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: MobileAppBar(
        scaffoldKey: scaffoldKey,
      ),
      drawer: mobileScreenDrawer(context),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
                Theme.of(context).colorScheme.surface,
              ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Welcome Back, Admin',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        navigateTo(const NotificationScreen(), context);
                      },
                      icon: notiBox.isNotEmpty
                          ? const Icon(
                              Icons.notifications,
                              color: Colors.yellow,
                              size: 30,
                            )
                          : const Icon(
                              Icons.notifications_off,
                              color: Colors.yellow,
                              size: 30,
                            ))
                ],
              ),
              Text(
                DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  DashBoardContainer(
                      icon: Icons.book,
                      subHead: 'Total Books',
                      boxColor: Colors.pink,
                      count: totalBook!),
                  const SizedBox(width: 20),
                  DashBoardContainer(
                      boxColor: Colors.blue,
                      icon: Icons.groups,
                      subHead: 'Members',
                      count: memberCount!),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  DashBoardContainer(
                      boxColor: Colors.green,
                      icon: Icons.menu_book_rounded,
                      subHead: 'Available',
                      count: availableBook == '0' ? '0' : availableBook!),
                  const SizedBox(width: 20),
                  DashBoardContainer(
                      boxColor: Colors.orange,
                      icon: Icons.book_sharp,
                      subHead: 'Requests',
                      count: requestBook == null ? '0' : requestBook!),
                ],
              ),
              const SizedBox(height: 30),
              Text('Quick Access',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Row(
                children: [
                  QuickContainer(
                    boxColor: Colors.pink,
                    icon: Icons.chrome_reader_mode_outlined,
                    subHead: 'Membership Plan',
                    navigate: () => navigateTo(const MembershipPlan(), context),
                  ),
                  const SizedBox(width: 20),
                  QuickContainer(
                      boxColor: Colors.blue,
                      icon: Icons.menu_book_sharp,
                      subHead: 'Books List',
                      navigate: () => navigateTo(const ListOfBooks(), context)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  QuickContainer(
                    boxColor: Colors.green,
                    icon: Icons.content_paste_go_rounded,
                    subHead: 'Request Book',
                    navigate: () =>
                        navigateTo(const RequestBookScreen(), context),
                  ),
                  const SizedBox(width: 20),
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
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
          clearNavigateToHome(const DashboardScreen(), context);
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Hive.box<BooksClass>('booksDetials').listenable().addListener(loadValues);
    Hive.box<BorrowedBookClass>('borrowedBooks')
        .listenable()
        .addListener(loadValues);
    Hive.box<MemberClass>('members').listenable().addListener(loadValues);
    Hive.box<RequestBookClass>('requestedBooks')
        .listenable()
        .addListener(loadValues);
  }
}
