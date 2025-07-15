import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:librrr_management/screens/dash%20board/src_home_page.dart';
import 'package:librrr_management/utilities/const_value.dart';
import 'package:librrr_management/widgets/about_test_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatelessWidget {
  final String? skipButton;
  final IconData icon;
  final String headText;
  final String text;
  final int highlightedDotIndex;
  final VoidCallback onNext;
  final String buttonText;

  const IntroScreen({
    super.key,
    this.skipButton,
    required this.icon,
    required this.headText,
    required this.text,
    required this.highlightedDotIndex,
    required this.onNext,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black26,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    Theme.of(context).colorScheme.surface
                  ])),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  bool isWeb = constraints.maxWidth > 600;

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: isWeb ? 140 : 100,
                            width: isWeb ? 140 : 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                icon,
                                size: isWeb ? 80 : 60,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            headText,
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            text,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 120),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(4, (index) {
                              bool isActive = index == highlightedDotIndex;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                height: 15,
                                width: isActive ? 30 : 15,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: onNext,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: isWeb ? 80 : 40,
                                  vertical: isWeb ? 14 : 7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ).copyWith(
                              // ignore: deprecated_member_use
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.black,
                              ),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Container(
                                constraints: const BoxConstraints(
                                    minWidth: 150, minHeight: 45),
                                alignment: Alignment.center,
                                child: Text(
                                  buttonText,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
                right: 20,
                top: 50,
                child: TextButton(
                    onPressed: () {
                      resistingIntro(context);
                      clearNavigateToHome(const DashboardScreen(), context);
                    },
                    child: AboutTestStyle(
                      text: 'Skip',
                      styleText: Theme.of(context).textTheme.titleLarge,
                    ))),
          ],
        ));
  }
}

// function to turn off intro page not showing again
Future<void> resistingIntro(BuildContext context) async {
  final shared = await SharedPreferences.getInstance();
  await shared.setBool(isSelected, true);
  log('skip button is pressed from intro page');
}
