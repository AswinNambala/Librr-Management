import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// to turn off intro screen
const String isSelected = 'userselected';

// default days for borrowing books from the library
int defualtDaysToBorrow = 14;

// each plan number of books a member can borrow from the library per months
const int basePlanBookCount = 4;
const int standardPlanBookCount = 8;
const int maximumBookCount = 12;

// object for notification
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// books genres list
final List<String> booksGenres = [
  'Fantasy',
  'Sci-Fi',
  'Mystery',
  'Thriller ',
  'Romance',
  'Comedy ',
  'Supernatural',
  'Historical Fiction',
  'Adventure ',
  'Actions',
  'Biography ',
  'Personal Development',
  'Travel',
  'Finance',
  'Cooking '
];

// books language list
final List<String> bookLanguage = ['English', 'Malayalam', 'Hindi'];

