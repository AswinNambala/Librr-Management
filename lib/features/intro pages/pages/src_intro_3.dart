import 'package:flutter/material.dart';
import 'package:librrr_management/features/intro%20pages/widget/intro_page.dart';
import 'package:librrr_management/features/intro%20pages/pages/src_intro_4.dart';

class IntroScreen3 extends StatelessWidget {
  const IntroScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroScreen(
        skipButton: 'Skip',
          icon: Icons.bar_chart,
          headText: 'Task Performances',
          text:
              'Get details insights and analytical about your’s library performance',
          highlightedDotIndex: 2,
          onNext: () {
            Navigator.of(context).pushReplacement(PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => const IntroScreen4(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero));
          },
          buttonText: 'Next'),
    );
  }
}
