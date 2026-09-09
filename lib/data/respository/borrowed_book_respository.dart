import 'package:hive/hive.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';

class BorrowedBooksRepository {
  BorrowedBooksRepository(this.box);
  final Box<BorrowedBookClass> box;

  List<BorrowedBookClass> getAll() => box.values.toList();
  Future<void> add(BorrowedBookClass book) => box.add(book);
  Stream<BoxEvent> watch() => box.watch();

  int activeCountForMember(String memberId) =>
      box.values.where((b) => b.memberId == memberId).length;
}