import 'package:hive/hive.dart';
import 'package:librrr_management/data/models/books/books%20_class.dart';

class BooksRepository {
  BooksRepository(this.box);
  final Box<BooksClass> box;

  List<BooksClass> getAll() => box.values.toList();
  Future<void> addBook(BooksClass book) => box.add(book);
  Future<void> updateBookAt(int index, BooksClass book) =>
      box.putAt(index, book);
  int indexOf(BooksClass book) => box.values.toList().indexOf(book);
  Stream<BoxEvent> watch() => box.watch();

  int indexOfShelf(String bookShelf) =>
      box.values.toList().indexWhere((b) => b.bookShelf == bookShelf);

  Future<bool> decrementStock(String bookShelf) async {
    final index = indexOfShelf(bookShelf);
    if (index == -1) return false;
    final book = box.getAt(index)!;
    final current = int.tryParse(book.numberOfBooks) ?? 0;
    if (current < 1) return false;
    book.numberOfBooks = (current - 1).toString();
    await box.putAt(index, book);
    return true;
  }
}
