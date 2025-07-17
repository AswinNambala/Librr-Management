import 'package:flutter/material.dart';

class AboutTestStyle extends StatelessWidget {
  final String? text;
  final TextStyle? styleText;
  const AboutTestStyle(
      {super.key, this.text, this.styleText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.2),
      child: Text(
        text!,
        style: styleText,
      ),
    );
  }
}

// function for navigating to any page
void navigateTo(Widget page, BuildContext context) {
  Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, anim1, anim2) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero));
}

void clearNavigateToHome(Widget page, BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
          pageBuilder: (context, anim1, anim2) => page,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero),
      (route) => false);
}
