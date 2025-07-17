import 'package:flutter/material.dart';
import 'package:librrr_management/features/dash%20board/pages/src_home_page.dart';
import 'package:librrr_management/features/intro%20pages/widget/intro_page.dart';


class IntroScreen4 extends StatelessWidget {
  const IntroScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroScreen(
        icon: Icons.groups,
        headText: 'Members Management',
        text: 'Handle membership, borrowings and donation with ease ',
        highlightedDotIndex: 3,
        onNext: () {
          Navigator.of(context).pushReplacement(PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => const DashboardScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero));
          resistingIntro(context);
        },
        buttonText: 'Finished',
      ),
    );
  }

  
}
