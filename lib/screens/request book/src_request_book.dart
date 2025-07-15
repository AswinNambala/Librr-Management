import 'package:flutter/material.dart';
import 'package:librrr_management/controllers/common%20functions/books_utils.dart';
import 'package:librrr_management/controllers/db%20functions/requested_books_db_utils.dart';
import 'package:librrr_management/models/requested_books/request_book_class.dart';
import 'package:librrr_management/widgets/all_text_form_field.dart';
import 'package:librrr_management/widgets/appbar_for_all.dart';

class RequestBookScreen extends StatefulWidget {
  const RequestBookScreen({super.key});

  @override
  State<RequestBookScreen> createState() => _RequestBookScreenState();
}

class _RequestBookScreenState extends State<RequestBookScreen> {
  final TextEditingController rBookName = TextEditingController();
  final TextEditingController rAuthorName = TextEditingController();
  final TextEditingController rLanguage = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarForAll(
        appBarTitle: 'Request Book',
        navToBorrow: false,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > 700;
        return Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AllTextFormField(
                controller: rBookName,
                hint: 'Enter book name',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'field is empty';
                  } else if (value.length < 3) {
                    return 'Atleast 3 letter needed';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              AllTextFormField(
                controller: rAuthorName,
                hint: 'Enter author name',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'field is empty';
                  } else if (value.length < 3) {
                    return 'Atleast 3 letter needed';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              AllTextFormField(
                controller: rLanguage,
                hint: 'Enter book language',
                onTap: () =>
                    BooksUtils.addBookSelectLanguage(context, (language) {
                  setState(() {
                    rLanguage.text = language;
                  });
                }),
              ),
              const SizedBox(
                height: 15,
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
                          backgroundColor: Colors.red.withOpacity(0.8)),
                      onPressed: () {
                        final rbooksInfo = RequestBookClass(
                            rBookName.text.trim(),
                            rAuthorName.text.trim(),
                            rLanguage.text.trim());
                        DbRequestBookUtils.savingRequestedBooks(
                            context, rbooksInfo);
                      },
                      child: const Text(
                        'save',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      )),
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}
