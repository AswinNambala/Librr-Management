import 'package:flutter/material.dart';
import 'package:librrr_management/screens/about/src_about.dart';
import 'package:librrr_management/screens/books/src_list_of_books.dart';
import 'package:librrr_management/screens/late_entry/src_late_entry_book.dart';
import 'package:librrr_management/screens/members/src_member_list.dart';
import 'package:librrr_management/screens/members/src_membership_plan.dart';
import 'package:librrr_management/screens/qr%20code/qr_code.dart';
import 'package:librrr_management/screens/report/src_report.dart';
import 'package:librrr_management/screens/request%20book/src_list_of_request_book.dart';
import 'package:librrr_management/screens/settings/src_setting.dart';
import 'package:librrr_management/widgets/about_test_style.dart';

// appbar of mobile screen home page
class MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
 const MobileAppBar({super.key, required this.scaffoldKey});

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 3),
              blurRadius: 6,
            )
          ],
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary
                ]),
                borderRadius: BorderRadius.circular(12)),
            child: Image.asset(
              "assets/home icons.png",
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          const Text(
            'Librr Management',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              letterSpacing: 1,
              color: Colors.white,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => scaffoldKey.currentState!.openDrawer(),
              icon: const Icon(Icons.menu, size: 28, color: Colors.white),
              splashRadius: 24,
            ),
          ),
        ),
      ],
    );
  }
}

// mobile screen drawer sections of the home page
Widget? mobileScreenDrawer(BuildContext context) {
  final List<Map<String, dynamic>> drawerItems = [
    {'title': 'Membership Plans', 'widget': const MembershipPlan()},
    {'title': 'Members List', 'widget': const MemberList()},
    {'title': 'Books Lists', 'widget': const ListOfBooks()},
    {'title': 'List of Reqested Book', 'widget': const ListOfRequestBook()},
    {'title': 'Late Book Entry', 'widget': const LateEntryBooks()},
    {'title': 'Report', 'widget': const ReportScreen()},
    {'title': 'QR Code', 'widget': const QrCodeScreen()},
    {'title': 'Setting', 'widget': const SettingScreen()},
    {'title': 'About', 'widget': const AboutScreen()},
  ];
  return Drawer(
    shape: const RoundedRectangleBorder(),
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
                Theme.of(context).colorScheme.surface
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 130,
                child: DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.black),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        child: const Icon(Icons.person,
                            size: 30, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Welcome Admin',
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ...drawerItems.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      elevation: 2,
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceTint
                          .withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.arrow_forward_ios,
                            color: Colors.white),
                        title: Text(
                          item['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          navigateTo(item['widget'], context);
                        },
                        hoverColor: Colors.white.withOpacity(0.1),
                        splashColor: Colors.white.withOpacity(0.2),
                      ),
                    ),
                  )),
            ],
          ),
        ),
        const Positioned(
            bottom: 50,
            left: 100,
            child: Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ))
      ],
    ),
  );
}
