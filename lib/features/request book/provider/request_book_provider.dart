import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:librrr_management/data/models/requested_books/request_book_class.dart';
import 'package:librrr_management/data/respository/request_respository.dart';

final requestedBooksRepositoryProvider = Provider<RequestedBooksRepository>((ref) {
  return RequestedBooksRepository(Hive.box<RequestBookClass>('requestedBooks'));
});

final requestedBooksListProvider =
    StateNotifierProvider<RequestedBooksListNotifier, List<RequestBookClass>>((ref) {
  return RequestedBooksListNotifier(ref.watch(requestedBooksRepositoryProvider));
});

class RequestedBooksListNotifier extends StateNotifier<List<RequestBookClass>> {
  RequestedBooksListNotifier(this._repo) : super(_repo.getAll()) {
    _sub = _repo.watch().listen((_) => state = _repo.getAll());
  }

  final RequestedBooksRepository _repo;
  late final StreamSubscription _sub;

  Future<String?> addRequest(RequestBookClass book) async {
    if (book.rBookName.isEmpty || book.rAuthorName.isEmpty || book.rLanguage.isEmpty) {
      return 'Complete all fields';
    }
    await _repo.add(book);
    return null;
  }

  Future<void> removeRequest(RequestBookClass book) => _repo.remove(book);

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final requestedSearchQueryProvider = StateProvider<String>((ref) => '');
final requestedGridViewProvider = StateProvider<bool>((ref) => true);

final filteredRequestedBooksProvider = Provider<List<RequestBookClass>>((ref) {
  final books = ref.watch(requestedBooksListProvider);
  final query = ref.watch(requestedSearchQueryProvider).trim().toLowerCase();
  if (query.isEmpty) return books;
  return books.where((b) {
    return b.rBookName.toLowerCase().contains(query) ||
        b.rAuthorName.toLowerCase().contains(query);
  }).toList();
});