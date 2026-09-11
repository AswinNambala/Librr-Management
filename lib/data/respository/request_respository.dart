import 'package:hive/hive.dart';
import 'package:librrr_management/data/models/requested_books/request_book_class.dart';

class RequestedBooksRepository {
  RequestedBooksRepository(this.box);
  final Box<RequestBookClass> box;

  List<RequestBookClass> getAll() => box.values.toList();
  Stream<BoxEvent> watch() => box.watch();
  Future<void> add(RequestBookClass book) => box.add(book);
  Future<void> remove(RequestBookClass book) => book.delete();
}