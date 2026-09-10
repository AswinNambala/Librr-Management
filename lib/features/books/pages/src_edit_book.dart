import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librrr_management/data/models/books/books%20_class.dart';
import 'package:librrr_management/features/books/controllers/books_utils.dart';
import 'package:librrr_management/features/books/providers/book_providers.dart';
import 'package:librrr_management/core/helpers/all_text_form_field.dart';
import 'package:librrr_management/core/helpers/appbar_for_all.dart';
import 'package:librrr_management/core/helpers/snackbar_for_all.dart';
import 'package:librrr_management/features/books/pages/src_list_of_books.dart';

class EditBooks extends ConsumerStatefulWidget {
  final BooksClass editBookInfo;
  const EditBooks({required this.editBookInfo, super.key});

  @override
  ConsumerState<EditBooks> createState() => _EditBooksState();
}

class _EditBooksState extends ConsumerState<EditBooks> {
  final _formKey = GlobalKey<FormState>();

  Uint8List? eBookImage;
  late TextEditingController eBookName;
  late TextEditingController eAuthorName;
  late TextEditingController eLanguage;
  late TextEditingController eNumberOfBook;
  late TextEditingController eGenre;
  late TextEditingController ePrice;
  late TextEditingController eBookId;

  @override
  void initState() {
    super.initState();
    final book = widget.editBookInfo;
    eBookImage = book.imageBook;
    eBookName = TextEditingController(text: book.booksName);
    eAuthorName = TextEditingController(text: book.authorName);
    eLanguage = TextEditingController(text: book.language);
    eNumberOfBook = TextEditingController(text: book.numberOfBooks);
    eGenre = TextEditingController(text: book.booksGenre);
    ePrice = TextEditingController(text: book.booksPrice);
    eBookId = TextEditingController(text: book.bookShelf);
  }

  @override
  void dispose() {
    eBookName.dispose();
    eAuthorName.dispose();
    eLanguage.dispose();
    eNumberOfBook.dispose();
    eGenre.dispose();
    ePrice.dispose();
    eBookId.dispose();
    super.dispose();
  }

  Future<void> _onUpdate() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final updatedBook = BooksClass(
      eBookImage,
      eBookName.text.trim(),
      eAuthorName.text.trim(),
      eLanguage.text.trim(),
      eNumberOfBook.text.trim(),
      eGenre.text.trim(),
      ePrice.text.trim(),
      eBookId.text.trim(),
    );

    final error = await ref
        .read(booksListProvider.notifier)
        .updateBook(widget.editBookInfo, updatedBook);
    if (!mounted) return;

    if (error != null) {
      SnackBarForAll.showError(context, error);
      return;
    }

    SnackBarForAll.showSuccess(context, 'Book updation successfully');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ListOfBooks()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarForAll(
          appBarTitle: 'Edit Books',
          navToBorrow: false,
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          bool isWeb = constraints.maxWidth > 600;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      height: isWeb ? 500 : 200,
                      width: isWeb ? 500 : 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          BooksUtils.editBookImage(
                              context: context,
                              repository: ref.read(booksRepositoryProvider),
                              currentImage: eBookImage,
                              bookInfo: widget.editBookInfo,
                              onImageUpdated: (newImage) {
                                setState(() {
                                  eBookImage = newImage;
                                });
                              });
                        },
                        child: eBookImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.memory(
                                  eBookImage!,
                                  fit: BoxFit.cover,
                                  height: isWeb ? 500 : 200,
                                  width: isWeb ? 500 : 200,
                                ),
                              )
                            : const Icon(Icons.menu_book, size: 60),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AllTextFormField(controller: eBookName, readOnly: true),
                    const SizedBox(height: 15),
                    AllTextFormField(controller: eAuthorName, readOnly: true),
                    const SizedBox(height: 15),
                    AllTextFormField(controller: eLanguage, readOnly: true),
                    const SizedBox(height: 15),
                    AllTextFormField(
                      controller: eNumberOfBook,
                      hint: 'Update the stock',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field is empty';
                        } else if (int.tryParse(value) == null) {
                          return 'Only numbers are accepted';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    AllTextFormField(controller: eGenre, readOnly: true),
                    const SizedBox(height: 15),
                    AllTextFormField(
                      controller: ePrice,
                      hint: 'Enter new price',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field is empty';
                        } else if (int.tryParse(value) == null) {
                          return 'Only numbers are accepted';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    AllTextFormField(controller: eBookId, readOnly: true),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: isWeb
                                    ? const Size(400, 50)
                                    : const Size(170, 40),
                                backgroundColor:
                                    Colors.black.withValues(alpha: 0.8)),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(color: Colors.red),
                            )),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: isWeb
                                  ? const Size(400, 50)
                                  : const Size(170, 40),
                              backgroundColor:
                                  Colors.red.withValues(alpha: 0.8),
                            ),
                            onPressed: _onUpdate,
                            child: const Text(
                              'Update',
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
