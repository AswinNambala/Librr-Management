import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:librrr_management/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/models/members/members_class.dart';
import 'package:librrr_management/models/notifications/notification_class.dart';
import 'package:librrr_management/utilities/const_value.dart';

class NotificationsUtils {
  static Future<void> showNotification(String title, String body) async {
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

  // check whether the member plan validity or borrowed books is late
  static Future<void> checkLateReturnsAndExpiredMemberships() async {
    final borrowedBox = Hive.box<BorrowedBookClass>('borrowedBooks');
    final membersBox = Hive.box<MemberClass>('members');

    final now = DateTime.now();
    for (final book in borrowedBox.values) {
      final format = DateFormat('dd-MM-yyyy');
      final returnDate = format.parseStrict(book.returnDate.trim());

      if (now.isAfter(returnDate)) {
        log('show notification');
        await showNotification(
          "Late Book Return",
          "Book ID: ${book.bookId}, Member ID: ${book.memberId}",
        );
        log('late book checking');
      }
    }

    for (final member in membersBox.values) {
      final expireDate = DateTime.tryParse(member.mExpireDate);
      if (expireDate != null && now.isAfter(expireDate)) {
        await showNotification(
          "Membership Expired",
          "${member.mFirstName} ${member.mLastName}'s membership has expired!",
        );
        log('members vaildity checking');
      } else {
        log('No members plan is expired');
      }
    }
  }
}

Future<void> initializeNotifications() async {
  if (kIsWeb) {
    log('screen is web not mobile phone so no notificaitons');
    return;
  }
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  if (Platform.isAndroid) {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final bool? granted = await androidPlugin?.requestNotificationsPermission();
    log('premission for notification done');
    if (granted != true) {
      log('Notification permission not granted on Android.');
    }
  }
}
