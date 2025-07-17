 import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:librrr_management/data/models/notifications/notification_class.dart';
import 'package:librrr_management/core/const_value.dart';

Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'late_books_channel',
      'Late Book Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails details =
        NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000, title, body, details);

    final box = Hive.box<NotificationClass>('notifications');
    box.add(NotificationClass(
      body,
      title,
      DateTime.now(),
    ));
    log('show notification is working');
  }