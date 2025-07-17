import 'package:flutter/material.dart';
import 'package:librrr_management/features/intro%20pages/widget/intro_page.dart';
import 'package:librrr_management/features/intro%20pages/pages/src_intro_2.dart';

class IntroScreen1 extends StatelessWidget {
  const IntroScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroScreen(
        skipButton: 'Skip',
          icon: Icons.local_library_rounded,
          headText: 'Library Admin',
          text: 'Your complete Library management solution',
          highlightedDotIndex: 0,
          onNext: () {
            Navigator.of(context).pushReplacement(PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => const IntroScreen2(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero));
          },
          buttonText: 'Next',),
    );
  }
}
