import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:librrr_management/controllers/db%20functions/borrowed_books_db_utils.dart';
import 'package:librrr_management/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/controllers/common%20functions/borrowed_book_utils.dart';
import 'package:librrr_management/utilities/const_value.dart';
import 'package:librrr_management/widgets/all_text_form_field.dart';
import 'package:librrr_management/widgets/appbar_for_all.dart';

class AddBorrowedBooks extends StatefulWidget {
  final String bookName;
  final String bookId;
  final String bookLang;
  const AddBorrowedBooks(
      {super.key,
      required this.bookName,
      required this.bookId,
      required this.bookLang});

  @override
  State<AddBorrowedBooks> createState() => _AddBorrowedBooksState();
}

class _AddBorrowedBooksState extends State<AddBorrowedBooks> {
  final TextEditingController brBookId = TextEditingController();
  final TextEditingController brMemberId = TextEditingController();
  final TextEditingController brBookName = TextEditingController();
  final TextEditingController brBookLanguage = TextEditingController();
  final TextEditingController brMemberName = TextEditingController();
  final TextEditingController brMemberVaildity = TextEditingController();
  final TextEditingController brBorrowedDate = TextEditingController();
  final TextEditingController brReturnDate = TextEditingController();
  @override
  void initState() {
    super.initState();
    loading();
  }

  void loading() {
    setState(() {
      brBookName.text = widget.bookName;
      brBookId.text = widget.bookId;
      brBookLanguage.text = widget.bookLang;
      brMemberId.text = 'LB';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarForAll(
        appBarTitle: 'Add Borrowed Books',
        navToBorrow: true,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > 700;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AllTextFormField(
                  controller: brBookId,
                  hint: 'Enter Book Id',
                  readOnly: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                AllTextFormField(
                  controller: brBookName,
                  hint: 'Display book Name',
                  readOnly: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                AllTextFormField(
                  controller: brBookLanguage,
                  hint: 'Display book language',
                  readOnly: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                AllTextFormField(
                  controller: brMemberId,
                  hint: "Enter members Id",
                  onChange: (value) {
                    BorrowedBookUtils.borrowedBookAutoFillMembersDetails(
                        value.trim(), brMemberName, brMemberVaildity);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                AllTextFormField(
                  controller: brMemberName,
                  hint: 'Display Members name',
                  readOnly: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                AllTextFormField(
                  controller: brMemberVaildity,
                  hint: 'Members plan expire date',
                  readOnly: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                AllTextFormField(
                  controller: brBorrowedDate,
                  hint: 'Display borrowed date',
                  readOnly: true,
                  onTap: () {
                    setState(() {
                      final todaysDate = DateTime.now();
                      final formatter = DateFormat('dd-MM-yyyy');
                      brBorrowedDate.text = formatter.format(todaysDate);
                    });
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                AllTextFormField(
                  controller: brReturnDate,
                  hint: 'Select a date',
                  keyboardType: TextInputType.number,
                  onTap: () {
                    BorrowedBookUtils.borrowedBookExpireDatePicker(
                        context, brReturnDate);
                  },
                  validator: (value) {
                    if (value?.isNotEmpty == true) {
                      if (BorrowedBookUtils.borrowedBookReturnDateValidate(
                          context, brReturnDate, brMemberVaildity)) {
                        return 'Return date should be before members expire date';
                      }
                    } else {
                      return 'Select a date to return book';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Note : default days for borrowing is $defualtDaysToBorrow',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  'Note : For late return, the fine amount per days will be ₹5',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                 const SizedBox(
                  height: 3,
                ),
                Text(
                  'Note : If book is damaged, full price of book will be collected as fine',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: isWeb
                                ? const Size(400, 50)
                                : const Size(170, 40),
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
                            fixedSize: isWeb
                                ? const Size(400, 50)
                                : const Size(170, 40),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary),
                        onPressed: () {
                          final newBorrowedBook = BorrowedBookClass(
                              brBookId.text.trim(),
                              brBookName.text.trim(),
                              brBookLanguage.text.trim(),
                              brMemberId.text.trim(),
                              brMemberName.text.trim(),
                              brBorrowedDate.text.trim(),
                              brReturnDate.text.trim());
                          DbBorrowedBooksUtils.borrowedBookSaveBorrowedBook(
                              context, newBorrowedBook);
                        },
                        child: Text(
                          'Save',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: Colors.white),
                        )),
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
