import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:librrr_management/features/dash%20board/pages/src_home_page.dart';
import 'package:librrr_management/features/intro%20pages/pages/src_intro_1.dart';
import 'package:librrr_management/core/const_value.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    log('Entered to splash screen');
    loading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Image.asset(
          'assets/logo for librr1.png',
          width: 300,
          height: 300,
        ),
      ),
    );
  }

  Future<void> loading() async {
    final sharedPref = await SharedPreferences.getInstance();
    final shared = sharedPref.getBool(isSelected) ?? false;
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    if (shared) {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              const DashboardScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero));
    } else {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              const IntroScreen1(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero));
    }
  }
}
