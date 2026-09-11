import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/data/models/members/members_class.dart';
import 'package:librrr_management/data/models/notifications/notification_class.dart';
import 'package:librrr_management/features/notifications/widget/notification.dart';
import 'package:librrr_management/core/const_value.dart';

class NotificationsUtils {
  static Future<void> checkLateReturnsAndExpiredMemberships() async {
    final borrowedBox = Hive.box<BorrowedBookClass>('borrowedBooks');
    final membersBox = Hive.box<MemberClass>('members');
    final notificationsBox = Hive.box<NotificationClass>('notifications');
    final format = DateFormat('dd-MM-yyyy');
    final now = DateTime.now();

    for (final book in borrowedBox.values) {
      DateTime returnDate;
      try {
        returnDate = format.parseStrict(book.returnDate.trim());
      } on FormatException {
        log('skipping book ${book.bookId}: unparsable returnDate "${book.returnDate}"');
        continue;
      }

      if (now.isAfter(returnDate)) {
        final body = "Book ID: ${book.bookId}, Member ID: ${book.memberId}";
        final alreadyNotified =
            notificationsBox.values.any((n) => n.title == "Late Book Return" && n.body == body);
        if (!alreadyNotified) {
          log('show late-return notification');
          await showNotification("Late Book Return", body);
        }
      }
    }

    for (final member in membersBox.values) {
      DateTime? expireDate;
      try {
        expireDate = format.parseStrict(member.mExpireDate.trim());
      } on FormatException {
        log('skipping member ${member.mMembersId}: unparsable mExpireDate "${member.mExpireDate}"');
        continue;
      }

      if (now.isAfter(expireDate)) {
        final body = "${member.mFirstName} ${member.mLastName}'s membership has expired!";
        final alreadyNotified =
            notificationsBox.values.any((n) => n.title == "Membership Expired" && n.body == body);
        if (!alreadyNotified) {
          await showNotification("Membership Expired", body);
        }
      }
    }
  }
}

Future<void> initializeNotifications() async {
  if (kIsWeb) {
    log('screen is web not mobile phone so no notifications');
    return;
  }
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  if (Platform.isAndroid) {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    final bool? granted = await androidPlugin?.requestNotificationsPermission();
    log('permission for notification done');
    if (granted != true) {
      log('Notification permission not granted on Android.');
    }
  }
}