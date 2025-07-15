import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:librrr_management/models/finished_books/finished_book_class.dart';

class FinishedBookUtils {
  //  calculating fine amount of members
  static String fineAmountCalculate(BuildContext context, String membersId) {
    final box = Hive.box<FinishedBookClass>('finishedBooks');
    List<FinishedBookClass> books = box.values.where((b) => b.memberId == membersId).toList();

    int sum = 0;
    for (var b in books) {
      if (b.fineAmount.isNotEmpty){
        int amount = int.parse(b.fineAmount.trim());
      sum += amount;
      }
      
    }
    return sum.toString();
  }
}
