import 'package:flutter/material.dart';
import 'package:librrr_management/features/books/pages/src_add_book.dart';
import 'package:librrr_management/features/request%20book/pages/src_request_book.dart';
import 'package:librrr_management/features/members/pages/src_add_members.dart';
import 'package:librrr_management/features/members/pages/src_membership_plan.dart';
import 'package:librrr_management/core/helpers/about_test_style.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  void _showAddActionSheet(BuildContext context) {
    final List<Map<String, dynamic>> addActions = [
      {'label': 'Add Book', 'widget': const AddBooks()},
      {'label': 'Add Member', 'widget': const AddMembersSCreen()},
      {'label': 'Add Request Book', 'widget': const RequestBookScreen()},
    ];

    void navigateTo(Widget screen) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => screen),
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Text('Choose an Action',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            ...addActions.map((action) {
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  title: Text(
                    action['label'],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    navigateTo(action['widget']);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, -3),
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[400],
          selectedFontSize: 14,
          unselectedFontSize: 13,
          currentIndex: currentIndex,
          onTap: (index) {
            if (index == 0) {
              _showAddActionSheet(context);
            } else if (index == 1) {
              onTap(index);
            } else {
              navigateTo(const MembershipPlan(), context);
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline, size: 30),
              activeIcon: Icon(Icons.add_circle, size: 40),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard, size: 30),
              activeIcon: Icon(Icons.dashboard, size: 40),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chrome_reader_mode_outlined, size: 30),
              activeIcon: Icon(Icons.chrome_reader_mode_outlined, size: 40),
              label: 'Plan',
            ),
          ],
        ),
      ),
    );
  }
}
