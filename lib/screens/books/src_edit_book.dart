import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:librrr_management/controllers/db%20functions/books_db_utils.dart';
import 'package:librrr_management/models/books/books%20_class.dart';
import 'package:librrr_management/controllers/common%20functions/books_utils.dart';
import 'package:librrr_management/widgets/all_text_form_field.dart';
import 'package:librrr_management/widgets/appbar_for_all.dart';

class EditBooks extends StatefulWidget {
  final BooksClass editBookInfo;
  final int index;
  const EditBooks({required this.editBookInfo, required this.index, super.key});

  @override
  State<EditBooks> createState() => _EditBooksState();
}

class _EditBooksState extends State<EditBooks> {
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
                            currentImage: eBookImage,
                            bookIndex: widget.index,
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
                          : const Icon(Icons.person, size: 60),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AllTextFormField(
                    controller: eBookName,
                    readOnly: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AllTextFormField(
                    controller: eAuthorName,
                    readOnly: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AllTextFormField(
                    controller: eLanguage,
                    readOnly: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AllTextFormField(
                    controller: eNumberOfBook,
                    hint: 'Update the stock',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AllTextFormField(
                    controller: eGenre,
                    readOnly: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AllTextFormField(
                    controller: ePrice,
                    hint: 'Enter new price',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AllTextFormField(
                    controller: eBookId,
                    readOnly: true,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                               fixedSize:
                              isWeb ? const Size(400, 50) : const Size(170, 40),
                              backgroundColor: Colors.black.withOpacity(0.8)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(color: Colors.red),
                          )),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                             fixedSize:
                              isWeb ? const Size(400, 50) : const Size(170, 40),
                            backgroundColor: Colors.red.withOpacity(0.8),
                          ),
                          onPressed: () {
                            final updatedBook = BooksClass(
                                eBookImage,
                                eBookName.text.trim(),
                                eAuthorName.text.trim(),
                                eLanguage.text.trim(),
                                eNumberOfBook.text.trim(),
                                eGenre.text.trim(),
                                ePrice.text.trim(),
                                eBookId.text.trim()
                                );

                            DbBooksUtils.editBookOnUpdatePressed(
                                context: context,
                                oldBook: widget.editBookInfo,
                                updatedBook: updatedBook);
                          },
                          child: const Text(
                            'Update',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          )),
                    ],
                  )
                ],
              ),
            ),
          );
        }));
  }
}
