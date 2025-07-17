import 'dart:developer';

import 'package:hive_flutter/adapters.dart';
import 'package:librrr_management/data/models/books/books%20_class.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/data/models/finished_books/finished_book_class.dart';
import 'package:librrr_management/data/models/members/members_class.dart';
import 'package:librrr_management/data/models/notifications/notification_class.dart';
import 'package:librrr_management/data/models/requested_books/request_book_class.dart';

Future<void> clearDataFromDB() async {
  await Hive.deleteBoxFromDisk('members');
  await Hive.deleteBoxFromDisk('booksDetials');
  await Hive.deleteBoxFromDisk('borrowedBooks');
  await Hive.deleteBoxFromDisk('finishedBooks');
  await Hive.deleteBoxFromDisk('requestedBooks');
  await Hive.deleteBoxFromDisk('notifications');
  log('hive database data is cleared');
}

Future<void> dbInitialize() async{
  await Hive.initFlutter();
  Hive.registerAdapter(MemberClassAdapter());
  await Hive.openBox<MemberClass>('members');
  Hive.registerAdapter(BooksClassAdapter());
  await Hive.openBox<BooksClass>('booksDetials');
  Hive.registerAdapter(BorrowedBookClassAdapter());
  await Hive.openBox<BorrowedBookClass>('borrowedBooks');
  Hive.registerAdapter(FinishedBookClassAdapter());
  await Hive.openBox<FinishedBookClass>('finishedBooks');
  Hive.registerAdapter(RequestBookClassAdapter());
  await Hive.openBox<RequestBookClass>('requestedBooks');
  Hive.registerAdapter(NotificationClassAdapter());
  await Hive.openBox<NotificationClass>('notifications');
  log('initialization is completed in hive');
}