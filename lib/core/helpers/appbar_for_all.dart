import 'package:flutter/material.dart';
import 'package:librrr_management/features/borrowed%20books/pages/src_borrowed_lists.dart';

class AppBarForAll extends StatelessWidget implements PreferredSizeWidget {
  final String appBarTitle;
  final bool navToBorrow;

  const AppBarForAll({
    required this.appBarTitle,
    required this.navToBorrow,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      leading: navToBorrow
          ? IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(PageRouteBuilder(
                    pageBuilder: (context, anim1, anim2) =>
                        const BorrowedBooksList(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero));
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ))
          : IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              )),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 3),
              blurRadius: 5,
            ),
          ],
        ),
      ),
      title: Text(
        appBarTitle,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          letterSpacing: 1,
          color: Colors.white,
        ),
      ),
    );
  }
}
