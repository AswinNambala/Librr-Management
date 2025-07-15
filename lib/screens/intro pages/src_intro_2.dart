import 'package:flutter/material.dart';
import 'package:librrr_management/screens/intro%20pages/widget/intro_page.dart';
import 'package:librrr_management/screens/intro%20pages/src_intro_3.dart';


class IntroScreen2 extends StatelessWidget {
  const IntroScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IntroScreen(
          skipButton: 'Skip',
            icon: Icons.book,
            headText: 'Manage Your Library',
            text:
                'Efficiently manage books, members and transactions all in one place',
            highlightedDotIndex: 1,
            onNext: () {
              Navigator.of(context).pushReplacement(PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => const IntroScreen3(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero));
            },
            buttonText: 'Next'));
  }
}
