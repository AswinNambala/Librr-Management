import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:librrr_management/data/data_sources/local_data/finished_books_db_utils.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/data/models/finished_books/finished_book_class.dart';
import 'package:librrr_management/features/members/widget/add_members.dart';
import 'package:librrr_management/core/helpers/all_text_form_field.dart';
import 'package:librrr_management/core/helpers/appbar_for_all.dart';
import 'package:librrr_management/core/helpers/snackbar_for_all.dart';

class LateEntryBooks extends StatefulWidget {
  final BorrowedBookClass? borrowedBookDetails;
  final int? index;
  const LateEntryBooks({super.key, this.borrowedBookDetails, this.index});

  @override
  State<LateEntryBooks> createState() => _LateEntryBooksState();
}

class _LateEntryBooksState extends State<LateEntryBooks> {
  final TextEditingController lMembersId = TextEditingController();
  final TextEditingController lMemberName = TextEditingController();
  final TextEditingController lOrgReturnDate = TextEditingController();
  final TextEditingController lReturnDate = TextEditingController();
  final TextEditingController lLateAmount = TextEditingController();
   bool paymentCompleted = false;

  @override
  void initState() {
    super.initState();
    if (widget.borrowedBookDetails != null) {
      lMemberName.text = widget.borrowedBookDetails!.memberName;
      lMembersId.text = widget.borrowedBookDetails!.memberId;
      lOrgReturnDate.text = widget.borrowedBookDetails!.returnDate;
      remainingDateCalculate();
    }
  }

  Future<void> remainingDateCalculate() async {
    int? countedDays;
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final DateTime expireDate =
        formatter.parse(widget.borrowedBookDetails!.returnDate);
    final int remainDate = expireDate.difference(DateTime.now()).inDays;
    setState(() {
      countedDays = remainDate;
    });
    int fine = countedDays! * 5;
    int amount = fine.abs();
    if (amount > 0) {
      lLateAmount.text = '$amount';
    } else {
      lLateAmount.text = 'No Fine';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarForAll(
        appBarTitle: 'Late book entry',
        navToBorrow: false,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > 700;
        return Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AllTextFormField(
                    controller: lMemberName,
                    hint: 'Member Name',
                    readOnly: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AllTextFormField(
                    controller: lMembersId,
                    hint: 'Members Id',
                    readOnly: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AllTextFormField(
                    controller: lOrgReturnDate,
                    hint: 'Return Date',
                    readOnly: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AllTextFormField(
                    controller: lReturnDate,
                    hint: 'Click for returned date',
                    onTap: () {
                      setState(() {
                        final todaysDate = DateTime.now();
                        final formatter = DateFormat('dd-MM-yyyy');
                        lReturnDate.text = formatter.format(todaysDate);
                      });
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AllTextFormField(
                    controller: lLateAmount,
                    hint: 'Fine Amount',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (paymentCompleted)
                   Row(
                      children: [
                        const Icon(
                          Icons.task_alt_outlined,
                          color: Colors.green,
                          size: 30,
                        ),
                        Text(
                          'Membership payment is now completed',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      ],
                    ),
                  const SizedBox(
                    height: 15,
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
                        if (!paymentCompleted)
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize: isWeb
                                      ? const Size(400, 50)
                                      : const Size(170, 40),
                                  backgroundColor:
                                      Colors.black.withOpacity(0.8)),
                              onPressed: () async {
                                bool cases =
                                    await bottomsheetforPayment(
                                        context);
                                if (cases) {
                                  setState(() {
                                    paymentCompleted = true;
                                  });
                                }
                              },
                              child: Text(
                                'Payment',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(color: Colors.red),
                              )),
                              if (paymentCompleted)
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize:
                              isWeb ? const Size(400, 50) : const Size(170, 40),
                            backgroundColor: Colors.red.withOpacity(0.8),
                          ),
                          onPressed: () {
                            if (lReturnDate.text.isEmpty ||
                                lMembersId.text.isEmpty ||
                                lMemberName.text.isEmpty ||
                                lOrgReturnDate.text.isEmpty ||
                                lLateAmount.text.isEmpty) {
                              SnackBarForAll.showError(
                                  context, 'All field is not completed');
                            } else {
                              final lateBook = FinishedBookClass(
                                  widget.borrowedBookDetails!.bookName,
                                  widget.borrowedBookDetails!.bookId,
                                  lMembersId.text.trim(),
                                  lMemberName.text.trim(),
                                  lLateAmount.text.trim(),
                                  lReturnDate.text.trim());
                              DbFinishedBookUtils.finishedBookSave(
                                  context, lateBook, widget.index!);
                              SnackBarForAll.showSuccess(
                                  context, 'Successfully paid fine');
                            }
                          },
                          child: const Text(
                            'Fine paid',
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
