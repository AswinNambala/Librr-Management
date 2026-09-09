import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librrr_management/data/models/books/books%20_class.dart';
import 'package:librrr_management/data/models/requested_books/request_book_class.dart';
import 'package:librrr_management/features/books/controllers/books_utils.dart';
import 'package:librrr_management/features/books/providers/book_providers.dart';
import 'package:librrr_management/features/books/widgets/book_add_section.dart';
import 'package:librrr_management/core/helpers/all_text_form_field.dart';
import 'package:librrr_management/core/helpers/appbar_for_all.dart';
import 'package:librrr_management/core/helpers/snackbar_for_all.dart';
import 'package:librrr_management/features/books/pages/src_list_of_books.dart';

class AddBooks extends ConsumerStatefulWidget {
  final RequestBookClass? reBookDetails;
  const AddBooks({super.key, this.reBookDetails});

  @override
  ConsumerState<AddBooks> createState() => _AddBooksState();
}

class _AddBooksState extends ConsumerState<AddBooks> {
  final _formKey = GlobalKey<FormState>();

  Uint8List? bookImageFile;
  final TextEditingController bName = TextEditingController();
  final TextEditingController bAuthorName = TextEditingController();
  final TextEditingController bLanguage = TextEditingController();
  final TextEditingController bNumberOfBooks = TextEditingController();
  final TextEditingController bPrice = TextEditingController();
  final TextEditingController bGenere = TextEditingController();
  final TextEditingController bBooksId = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.reBookDetails != null) {
      bName.text = widget.reBookDetails!.rBookName;
      bAuthorName.text = widget.reBookDetails!.rAuthorName;
      bLanguage.text = widget.reBookDetails!.rLanguage;
    }
  }

  @override
  void dispose() {
    bName.dispose();
    bAuthorName.dispose();
    bLanguage.dispose();
    bNumberOfBooks.dispose();
    bPrice.dispose();
    bGenere.dispose();
    bBooksId.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (bLanguage.text.trim().isEmpty ||
        bGenere.text.trim().isEmpty ||
        bBooksId.text.trim().isEmpty) {
      SnackBarForAll.showError(
          context, 'Please select language, genre and a book id');
      return;
    }

    final newBook = BooksClass(
      bookImageFile,
      bName.text.trim(),
      bAuthorName.text.trim(),
      bLanguage.text.trim(),
      bNumberOfBooks.text.trim(),
      bGenere.text.trim(),
      bPrice.text.trim(),
      bBooksId.text.trim(),
    );

    final error = await ref.read(booksListProvider.notifier).addBook(newBook);
    if (!mounted) return;

    if (error != null) {
      SnackBarForAll.showError(context, error);
      return;
    }

    SnackBarForAll.showSuccess(context, 'New book is added to book shelf');
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, anim1, anim2) => const ListOfBooks(),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarForAll(
        appBarTitle: 'Add Books Details',
        navToBorrow: false,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > 700;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white)),
                    child: GestureDetector(
                      onTap: () =>
                          BooksUtils.addBookPickBookImage(context, (bytes) {
                        setState(() {
                          bookImageFile = bytes;
                        });
                      }),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          bookImageFile == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 50,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Add Photo',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    )
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.memory(
                                    bookImageFile!,
                                    fit: BoxFit.cover,
                                    width: 150,
                                    height: 150,
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AllTextFormField(
                    controller: bName,
                    hint: 'Book Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is empty';
                      } else if (value.length < 3) {
                        return 'minimum of 3 letter is neccesary';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  AllTextFormField(
                    controller: bAuthorName,
                    hint: 'Author Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is empty';
                      } else if (value.length < 3) {
                        return 'minimum of 3 letter is neccesary';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  AllTextFormField(
                    controller: bLanguage,
                    hint: 'Language',
                    readOnly: true,
                    onTap: () => addBookSelectLanguage(context, (language) {
                      setState(() {
                        bLanguage.text = language;
                      });
                    }),
                  ),
                  const SizedBox(height: 15),
                  AllTextFormField(
                    controller: bNumberOfBooks,
                    hint: 'No.of Books',
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
                  AllTextFormField(
                    controller: bGenere,
                    readOnly: true,
                    hint: 'Books Genere',
                    onTap: () => addBookSelectGenre(context, (genre) {
                      setState(() {
                        bGenere.text = genre;
                      });
                    }),
                  ),
                  const SizedBox(height: 15),
                  AllTextFormField(
                    controller: bPrice,
                    hint: 'Book Price',
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
                  AllTextFormField(
                    hint: 'Book Id',
                    controller: bBooksId,
                    onTap: () => BooksUtils.addBookIdGenerate(context, (id) {
                      setState(() {
                        bBooksId.text = id;
                      });
                    }),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: isWeb
                                  ? const Size(400, 50)
                                  : const Size(140, 30),
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
                                : const Size(140, 30),
                            backgroundColor: Colors.red.withValues(alpha: 0.8),
                          ),
                          onPressed: _onSave,
                          child: const Text(
                            'Save',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}