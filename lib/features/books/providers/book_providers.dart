import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:librrr_management/data/models/books/books%20_class.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/data/models/finished_books/finished_book_class.dart';
import 'package:librrr_management/data/respository/book_respository.dart';

final booksRepositoryProvider = Provider<BooksRepository>((ref) {
  return BooksRepository(Hive.box<BooksClass>('booksDetials'));
});

final booksListProvider =
    StateNotifierProvider<BooksListNotifier, List<BooksClass>>((ref) {
  final repo = ref.watch(booksRepositoryProvider);
  return BooksListNotifier(repo);
});

class BooksListNotifier extends StateNotifier<List<BooksClass>> {
  BooksListNotifier(this._repo) : super(_repo.getAll()) {
    _sub = _repo.watch().listen((_) => state = _repo.getAll());
  }

  final BooksRepository _repo;
  late final StreamSubscription _sub;

  /// Returns null on success, or an error message to show the user.
  Future<String?> addBook(BooksClass book) async {
    final error = _validate(book);
    if (error != null) return error;
    await _repo.addBook(book);
    return null;
  }

  /// Returns null on success, or an error message to show the user.
  Future<String?> updateBook(BooksClass original, BooksClass edited) async {
    final error = _validate(edited);
    if (error != null) return error;
    await _repo.update(original, edited); // FIX: object-based, no index lookup
    return null;
  }

  Future<void> deleteBook(BooksClass book) => _repo.delete(book);

  String? _validate(BooksClass book) {
    if (book.booksName.isEmpty ||
        book.authorName.isEmpty ||
        book.language.isEmpty ||
        book.numberOfBooks.isEmpty ||
        book.booksGenre.isEmpty ||
        book.bookShelf.isEmpty) {
      return 'Complete all fields';
    }
    if (int.tryParse(book.numberOfBooks) == null) {
      return 'Number of books must be numeric';
    }
    if (int.tryParse(book.booksPrice) == null) {
      return 'Price must be numeric';
    }
    return null;
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

// List screen UI state
final bookSearchQueryProvider = StateProvider<String>((ref) => '');
final bookFilterLanguageProvider = StateProvider<String?>((ref) => null);
final bookFilterGenreProvider = StateProvider<String?>((ref) => null);
final bookGridViewProvider = StateProvider<bool>((ref) => true);

final filteredBooksProvider = Provider<List<BooksClass>>((ref) {
  final books = ref.watch(booksListProvider);
  final query = ref.watch(bookSearchQueryProvider).trim().toLowerCase();
  final language = ref.watch(bookFilterLanguageProvider);
  final genre = ref.watch(bookFilterGenreProvider);

  return books.where((book) {
    final matchesSearch = query.isEmpty ||
        book.booksName.toLowerCase().contains(query) ||
        book.bookShelf.toLowerCase().contains(query);
    final matchesLanguage = language == null || book.language == language;
    final matchesGenre = genre == null || book.booksGenre == genre;
    return matchesSearch && matchesLanguage && matchesGenre;
  }).toList();
});

// Book profile screen — history / borrowed, kept live via box.watch()

final bookHistoryProvider =
    StreamProvider.family<List<FinishedBookClass>, String>(
        (ref, bookId) async* {
  final box = Hive.box<FinishedBookClass>('finishedBooks');
  List<FinishedBookClass> read() =>
      box.values.where((b) => b.bookId == bookId).toList();
  yield read();
  yield* box.watch().map((_) => read());
});

final borrowedBooksForBookProvider =
    StreamProvider.family<List<BorrowedBookClass>, String>(
        (ref, bookId) async* {
  final box = Hive.box<BorrowedBookClass>('borrowedBooks');
  List<BorrowedBookClass> read() =>
      box.values.where((b) => b.bookId == bookId).toList();
  yield read();
  yield* box.watch().map((_) => read());
});
