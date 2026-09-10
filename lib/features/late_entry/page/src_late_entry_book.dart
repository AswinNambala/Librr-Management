import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/features/late_entry/provider/late_entry_provider.dart';
import 'package:librrr_management/features/members/widget/add_members.dart';
import 'package:librrr_management/core/helpers/all_text_form_field.dart';
import 'package:librrr_management/core/helpers/appbar_for_all.dart';
import 'package:librrr_management/core/helpers/snackbar_for_all.dart';

class LateEntryBooks extends ConsumerStatefulWidget {
  final BorrowedBookClass borrowedBookDetails;
  const LateEntryBooks({super.key, required this.borrowedBookDetails});

  @override
  ConsumerState<LateEntryBooks> createState() => _LateEntryBooksState();
}

class _LateEntryBooksState extends ConsumerState<LateEntryBooks> {
  final TextEditingController lMembersId = TextEditingController();
  final TextEditingController lMemberName = TextEditingController();
  final TextEditingController lOrgReturnDate = TextEditingController();
  final TextEditingController lReturnDate = TextEditingController();
  final TextEditingController lLateAmount = TextEditingController();
  bool paymentCompleted = false;

  @override
  void initState() {
    super.initState();
    lMemberName.text = widget.borrowedBookDetails.memberName;
    lMembersId.text = widget.borrowedBookDetails.memberId;
    lOrgReturnDate.text = widget.borrowedBookDetails.returnDate;
    _calculateFine();
  }

  @override
  void dispose() {
    lMembersId.dispose();
    lMemberName.dispose();
    lOrgReturnDate.dispose();
    lReturnDate.dispose();
    lLateAmount.dispose();
    super.dispose();
  }

  void _calculateFine() {
    final amount = lateEntryFineAmount(widget.borrowedBookDetails.returnDate);
    lLateAmount.text = amount > 0 ? '$amount' : 'No Fine';
  }

  Future<void> _onFinePaid() async {
    if (lReturnDate.text.isEmpty ||
        lMembersId.text.isEmpty ||
        lMemberName.text.isEmpty ||
        lOrgReturnDate.text.isEmpty ||
        lLateAmount.text.isEmpty) {
      SnackBarForAll.showError(context, 'All field is not completed');
      return;
    }

    final error = await ref.read(lateEntryNotifierProvider.notifier).finalizeLateReturn(
          borrowedBook: widget.borrowedBookDetails,
          returnedByMemberId: lMembersId.text,
          returnedByMemberName: lMemberName.text,
          fineAmountText: lLateAmount.text,
          returnDateText: lReturnDate.text,
        );

    if (!mounted) return;

    if (error != null) {
      SnackBarForAll.showError(context, error);
      return;
    }

    SnackBarForAll.showSuccess(context, 'Successfully paid fine');
    Navigator.pop(context);
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
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AllTextFormField(
                  controller: lMemberName,
                  hint: 'Member Name',
                  readOnly: true,
                ),
                const SizedBox(height: 15),
                AllTextFormField(
                  controller: lMembersId,
                  hint: 'Members Id',
                  readOnly: true,
                ),
                const SizedBox(height: 15),
                AllTextFormField(
                  controller: lOrgReturnDate,
                  hint: 'Return Date',
                  readOnly: true,
                ),
                const SizedBox(height: 15),
                AllTextFormField(
                  controller: lReturnDate,
                  hint: 'Click for returned date',
                  readOnly: true, 
                  onTap: () {
                    setState(() {
                      final todaysDate = DateTime.now();
                      final formatter = DateFormat('dd-MM-yyyy');
                      lReturnDate.text = formatter.format(todaysDate);
                    });
                  },
                ),
                const SizedBox(height: 15),
                AllTextFormField(
                  controller: lLateAmount,
                  hint: 'Fine Amount',
                ),
                const SizedBox(height: 10),
                if (paymentCompleted)
                  Row(
                    children: [
                      const Icon(
                        Icons.task_alt_outlined,
                        color: Colors.green,
                        size: 30,
                      ),
                      const SizedBox(width: 8), 
                      Expanded(
                        child: Text(
                          'Membership payment is now completed',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 15),
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
                    if (!paymentCompleted)
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: isWeb
                                  ? const Size(400, 50)
                                  : const Size(170, 40),
                              backgroundColor:
                                  Colors.black.withValues(alpha: 0.8)),
                          onPressed: () async {
                            bool cases = await bottomsheetforPayment(context);
                            if (!mounted) return;
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
                            fixedSize: isWeb
                                ? const Size(400, 50)
                                : const Size(170, 40),
                            backgroundColor: Colors.red.withValues(alpha: 0.8),
                          ),
                          onPressed: _onFinePaid,
                          child: const Text(
                            'Fine paid',
                            style: TextStyle(fontSize: 24, color: Colors.white),
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