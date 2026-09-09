import 'package:hive/hive.dart';
import 'package:librrr_management/data/models/books/books%20_class.dart';

/// Thin wrapper around the Hive box — the only place that touches
/// Hive directly for books.
class BooksRepository {
  BooksRepository(this.box);

  final Box<BooksClass> box;

  List<BooksClass> getAll() => box.values.toList();

  Future<void> addBook(BooksClass book) => box.add(book);

  Future<void> updateBookAt(int index, BooksClass book) =>
      box.putAt(index, book);

  int indexOf(BooksClass book) => box.values.toList().indexOf(book);

  Stream<BoxEvent> watch() => box.watch();
}