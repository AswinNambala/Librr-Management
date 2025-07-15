import 'dart:typed_data';
import 'package:hive/hive.dart';
    part 'books _class.g.dart';
@HiveType(typeId: 1)
class BooksClass {
  @HiveField(0)
  Uint8List? imageBook;
  @HiveField(1)
  String booksName;
  @HiveField(2)
  String authorName;
  @HiveField(3)
  String language;
  @HiveField(4)
  String numberOfBooks;
  @HiveField(5)
  String booksGenre;
  @HiveField(6) 
  String booksPrice;
  @HiveField(7)
  String bookShelf;
  BooksClass(
      this.imageBook,
      this.booksName,
      this.authorName,
      this.language,
      this.numberOfBooks,
      this.booksGenre,
      this.booksPrice,
      this.bookShelf);
}
