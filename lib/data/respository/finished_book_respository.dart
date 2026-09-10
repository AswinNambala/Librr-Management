import 'package:hive/hive.dart';
import 'package:librrr_management/data/models/finished_books/finished_book_class.dart';

class FinishedBooksRepository {
  FinishedBooksRepository(this.box);
  final Box<FinishedBookClass> box;

  Future<void> add(FinishedBookClass book) => box.add(book);
}