import 'package:hive_flutter/adapters.dart';
part 'finished_book_class.g.dart';

@HiveType(typeId: 3)
class FinishedBookClass {
  @HiveField(0)
  String bookName;
  @HiveField(1)
  String bookId;
  @HiveField(2)
  String memberId;
  @HiveField(3)
  String memberName;
  @HiveField(4)
  String fineAmount;
  @HiveField(5)
  String bookReturnedDate;
  FinishedBookClass(this.bookName, this.bookId, this.memberId, this.memberName,
      this.fineAmount, this.bookReturnedDate);
}
