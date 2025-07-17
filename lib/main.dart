import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:librrr_management/features/notifications/controllers/notifications_utils.dart';
import 'package:librrr_management/data/data_sources/local_data/db_main_functions.dart';
import 'package:librrr_management/splash/src_splash.dart';
import 'package:librrr_management/core/theme_class_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await clearDataFromDB();
  await dbInitialize();
  await initializeNotifications();
  runApp(const MyApp());
  log('main is completed');
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: darkTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
