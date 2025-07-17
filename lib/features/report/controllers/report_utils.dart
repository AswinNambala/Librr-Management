import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:librrr_management/data/models/books/books%20_class.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/data/models/finished_books/finished_book_class.dart';

class ReportUtils {
  static List<FlSpot> borrowedBooksMonthlyData(
      Box<BorrowedBookClass> box, BuildContext context) {
    Map<int, int> monthlyCount = {for (int i = 0; i <= 12; i++) i: 0};
    final formatter = DateFormat('dd-MM-yyyy');
    for (var book in box.values) {
      DateTime date = formatter.parse(book.borrowedDate);
      final month = date.month;
      monthlyCount[month] = (monthlyCount[month] ?? 0);
    }
    return List<FlSpot>.generate(12, (i) {
      final monthIndex = i + 1;
      return FlSpot(i.toDouble(), monthlyCount[monthIndex]!.toDouble());
    });
  }

  static List<FlSpot> borrowedBooksWeeklyData(
      Box<BorrowedBookClass> box, BuildContext context) {
    Map<int, int> weeklyCount = {for (int i = 0; i <= 7; i++) i: 0};
    final formatter = DateFormat('dd-MM-yyyy');
    for (var book in box.values) {
      DateTime date = formatter.parse(book.borrowedDate);
      final month = date.weekday;
      weeklyCount[month] = (weeklyCount[month] ?? 0);
    }
    return List<FlSpot>.generate(7, (i) {
      final weekIndex = i + 1;
      return FlSpot(i.toDouble(), weeklyCount[weekIndex]!.toDouble());
    });
  }

  // report page to count each genre of books
  static Map<String, int> reportFliterBooksGenre(List<String> genreList) {
    final box = Hive.box<BooksClass>('booksDetials');
    Map<String, int> genreCount = {for (var genre in genreList) genre: 0};
    final genreLast = genreList.last;
    for (BooksClass book in box.values) {
      final genre = book.booksGenre;
      if (genreList.contains(genre) && genre != genreLast) {
        genreCount[genre] = genreCount[genre]! + 1;
      } else {
        genreCount[genreLast] = genreCount[genreLast]! + 1;
      }
    }
    final Map<String, int> dataMap = {
      for (var b in genreCount.entries) b.key: b.value,
    };

    return dataMap;
  }

// colors for report page pie Chart data
  static final List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.grey,
    Colors.orange
  ];

  static List<PieChartSectionData> reportPieChartDataGet(BuildContext context,
      Map<String, int> genresCount) {
    final total = genresCount.values.fold(0, (sum, value) => sum + value);
    int index = 0;
    return genresCount.entries.map((entry) {
      final percent = (entry.value / total) * 100;
      return PieChartSectionData(
        color: colorList[index++ % colorList.length],
        value: percent,
        title: '${percent.toStringAsFixed(1)} %',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400)

      );
    }).toList();
  }

  // calculate the total fine amount recieved 
  static String fineAmountCalculate(BuildContext context) {
    final box = Hive.box<FinishedBookClass>('finishedBooks');
    int sum = 0;
    for (var b in box.values) {
      if (b.fineAmount.isNotEmpty){
        int amount = int.parse(b.fineAmount.trim());
      sum += amount;
      }
      
    }
    return sum.toString();
  }
}
