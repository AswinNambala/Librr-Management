import 'package:hive_flutter/adapters.dart';
import 'package:librrr_management/data/models/finished_books/finished_book_class.dart';
import 'package:librrr_management/features/members/providers/member_providers.dart';

class FinishedBookUtils {
  static String fineAmountCalculate(String membersId) {
    final box = Hive.box<FinishedBookClass>('finishedBooks');
    final books = box.values.where((b) => b.memberId == membersId).toList();
    return memberTotalFine(books).toString();
  }
}