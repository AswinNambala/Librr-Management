import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/features/borrowed%20books/providers/borrowed_book_providers.dart';
import 'package:librrr_management/features/borrowed%20books/widgets/add_borrowed_books.dart';
import 'package:librrr_management/features/borrowed%20books/controllers/borrowed_book_utils.dart';
import 'package:librrr_management/features/borrowed%20books/pages/src_borrowed_lists.dart';
import 'package:librrr_management/core/const_value.dart';
import 'package:librrr_management/core/helpers/all_text_form_field.dart';
import 'package:librrr_management/core/helpers/appbar_for_all.dart';
import 'package:librrr_management/core/helpers/snackbar_for_all.dart';

class AddBorrowedBooks extends ConsumerStatefulWidget {
  final String bookName;
  final String bookId;
  final String bookLang;
  const AddBorrowedBooks({
    super.key,
    required this.bookName,
    required this.bookId,
    required this.bookLang,
  });

  @override
  ConsumerState<AddBorrowedBooks> createState() => _AddBorrowedBooksState();
}

class _AddBorrowedBooksState extends ConsumerState<AddBorrowedBooks> {
  final _formKey = GlobalKey<FormState>();

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
    brBookName.text = widget.bookName;
    brBookId.text = widget.bookId;
    brBookLanguage.text = widget.bookLang;
    brMemberId.text = 'LB';
  }

  @override
  void dispose() {
    brBookId.dispose();
    brMemberId.dispose();
    brBookName.dispose();
    brBookLanguage.dispose();
    brMemberName.dispose();
    brMemberVaildity.dispose();
    brBorrowedDate.dispose();
    brReturnDate.dispose();
    super.dispose();
  }

  void _onMemberIdChanged(String value) {
    final result = ref.read(memberLookupProvider(value.trim()));
    setState(() {
      brMemberName.text = result.name;
      brMemberVaildity.text = result.expireDate;
    });
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (brBorrowedDate.text.trim().isEmpty) {
      SnackBarForAll.showError(context, 'Select the borrowed date');
      return;
    }

    final newBorrowedBook = BorrowedBookClass(
      brBookId.text.trim(),
      brBookName.text.trim(),
      brBookLanguage.text.trim(),
      brMemberId.text.trim(),
      brMemberName.text.trim(),
      brBorrowedDate.text.trim(),
      brReturnDate.text.trim(),
    );

    final error = await ref
        .read(borrowedBooksListProvider.notifier)
        .addBorrowedBook(newBorrowedBook);
    if (!mounted) return;

    if (error == 'MEMBER_LIMIT_EXCEEDED') {
      BorrowedBookUtils.showNoteMemberValidityExceeded(context);
      return;
    }
    if (error != null) {
      SnackBarForAll.showError(context, error);
      return;
    }

    SnackBarForAll.showSuccess(context, 'Marked as borrowed');
    Navigator.pop(context);
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, anim1, anim2) => const BorrowedBooksList(),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ));
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AllTextFormField(
                    controller: brBookId,
                    hint: 'Enter Book Id',
                    readOnly: true,
                  ),
                  const SizedBox(height: 15),
                  AllTextFormField(
                    controller: brBookName,
                    hint: 'Display book Name',
                    readOnly: true,
                  ),
                  const SizedBox(height: 15),
                  AllTextFormField(
                    controller: brBookLanguage,
                    hint: 'Display book language',
                    readOnly: true,
                  ),
                  const SizedBox(height: 15),
                  AllTextFormField(
                    controller: brMemberId,
                    hint: "Enter members Id",
                    validator: (value) {
                      if (value == null || value.trim().isEmpty || value.trim() == 'LB') {
                        return 'Enter a member id';
                      }
                      return null;
                    },
                    onChange: _onMemberIdChanged,
                  ),
                  const SizedBox(height: 15),
                  AllTextFormField(
                    controller: brMemberName,
                    hint: 'Display Members name',
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Member not found';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  AllTextFormField(
                    controller: brMemberVaildity,
                    hint: 'Members plan expire date',
                    readOnly: true,
                  ),
                  const SizedBox(height: 15),
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
                  const SizedBox(height: 15),
                  AllTextFormField(
                    controller: brReturnDate,
                    hint: 'Select a date',
                    readOnly: true, 
                    onTap: () {
                      borrowedBookExpireDatePicker(context, brReturnDate);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Select a date to return book';
                      }
                      if (borrowedReturnDateExceedsMemberExpiry(
                          brReturnDate.text, brMemberVaildity.text)) {
                        return 'Return date should be before members expire date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Note : default days for borrowing is $defualtDaysToBorrow',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Note : For late return, the fine amount per days will be ₹5',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Note : If book is damaged, full price of book will be collected as fine',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20),
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
                                  Theme.of(context).colorScheme.primary),
                          onPressed: _onSave,
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
          ),
        );
      }),
    );
  }
}