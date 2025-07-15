
import 'package:hive_flutter/adapters.dart';
    part 'borrowed_book_class.g.dart';
    @HiveType(typeId: 2)
class BorrowedBookClass {
  @HiveField(0)
  late String bookId;
  @HiveField(1)
  late String bookName;
  @HiveField(2)
  late String bookLanguage;
  @HiveField(3)
  late String memberId;
  @HiveField(4)
  late String memberName;
  @HiveField(5)
  late String borrowedDate;
  @HiveField(6)
  late String returnDate;

  BorrowedBookClass(this.bookId, this.bookName, this.bookLanguage, this.memberId,
      this.memberName, this.borrowedDate, this.returnDate);
}
