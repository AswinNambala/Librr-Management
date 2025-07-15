import 'package:flutter/material.dart';
import 'package:librrr_management/screens/about/src_about.dart';
import 'package:librrr_management/screens/books/src_add_book.dart';
import 'package:librrr_management/screens/books/src_list_of_books.dart';
import 'package:librrr_management/screens/borrowed%20books/src_borrowed_lists.dart';
import 'package:librrr_management/screens/dash%20board/web%20screen/web_src_dashboard.dart';
import 'package:librrr_management/screens/late_entry/src_late_entry_book.dart';
import 'package:librrr_management/screens/members/src_add_members.dart';
import 'package:librrr_management/screens/members/src_member_list.dart';
import 'package:librrr_management/screens/members/src_membership_plan.dart';
import 'package:librrr_management/screens/qr%20code/qr_code.dart';
import 'package:librrr_management/screens/report/src_report.dart';
import 'package:librrr_management/screens/request%20book/src_list_of_request_book.dart';
import 'package:librrr_management/screens/settings/src_setting.dart';

// website appbar section
class WebAppbarSection extends StatelessWidget implements PreferredSizeWidget {
  const WebAppbarSection({super.key});
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
         
        ],
      ),
    );
  }
}

// website menu option sections
class WebMenuSection extends StatefulWidget {
  final double size;
  const WebMenuSection({super.key, required this.size});

  @override
  State<WebMenuSection> createState() => _WebMenuSectionState();
}

class _WebMenuSectionState extends State<WebMenuSection> {
  final List<Map<String, dynamic>> webMenuItems = [
    {'title': 'Home', 'widget': const WebDashboardScreen()},
    {'title': 'Membership Plans', 'widget': const MembershipPlan()},
    {'title': 'Members List', 'widget': const MemberList()},
    {'title': 'Books Lists', 'widget': const ListOfBooks()},
    {'title': 'List of Reqested Book', 'widget': const ListOfRequestBook()},
    {'title': 'List of Borrowed Book', 'widget': const BorrowedBooksList()},
    {'title': 'Late Book Entry', 'widget': const LateEntryBooks()},
    {'title': 'Add Book', 'widget': const AddBooks()},
    {'title': 'Add Member', 'widget': const AddMembersSCreen()},
    {'title': 'Setting', 'widget': const SettingScreen()},
    {'title': 'About', 'widget': const AboutScreen()},
    {'title': 'Report', 'widget': const ReportScreen()},
    {'title': 'QR Code', 'widget': const QrCodeScreen()},
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.surface
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Menu',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: webMenuItems.length,
              itemBuilder: (context, index) {
                final isSelected = selectedIndex == index;
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => webMenuItems[index]['widget']),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.red.withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              webMenuItems[index]['title'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_outlined,
                              color: Colors.white, size: 14),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
