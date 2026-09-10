import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librrr_management/data/models/members/members_class.dart';
import 'package:librrr_management/features/borrowed%20books/providers/borrowed_book_providers.dart';
import 'package:librrr_management/features/members/controllers/member_utils.dart';
import 'package:librrr_management/features/members/providers/member_providers.dart' hide membersRepositoryProvider;
import 'package:librrr_management/features/members/widget/add_members.dart';
import 'package:librrr_management/features/members/pages/src_member_list.dart';
import 'package:librrr_management/core/helpers/all_text_form_field.dart';
import 'package:librrr_management/core/helpers/appbar_for_all.dart';
import 'package:librrr_management/core/helpers/snackbar_for_all.dart';

class EditMemberScreen extends ConsumerStatefulWidget {
  final MemberClass memberEditDetails;
  const EditMemberScreen({
    super.key,
    required this.memberEditDetails,
  });

  @override
  ConsumerState<EditMemberScreen> createState() => _EditMemberScreenState();
}

class _EditMemberScreenState extends ConsumerState<EditMemberScreen> {
  final _formKey = GlobalKey<FormState>();

  Uint8List? eImageEdited;
  late TextEditingController eFirstName;
  late TextEditingController eLastName;
  late TextEditingController eAddress;
  late TextEditingController ePhoneNumber;
  late TextEditingController ePinCode;
  late TextEditingController ePlan;
  late TextEditingController eGender;
  late TextEditingController eJoinDate;
  late TextEditingController eExpireDate;
  late TextEditingController eMembersId;
  String booksperMonth = '';
  bool paymentCompleted = false;
  bool paymentSection = false;

  @override
  void initState() {
    super.initState();
    final member = widget.memberEditDetails;
    eImageEdited = member.profileImage;
    eFirstName = TextEditingController(text: member.mFirstName);
    eLastName = TextEditingController(text: member.mLastName);
    eAddress = TextEditingController(text: member.mAddress);
    ePhoneNumber = TextEditingController(text: member.mPhoneNumber);
    ePinCode = TextEditingController(text: member.mPincode);
    ePlan = TextEditingController(text: member.mPlan);
    eGender = TextEditingController(text: member.mGender);
    eJoinDate = TextEditingController(text: member.mJoinDate);
    eExpireDate = TextEditingController(text: member.mExpireDate);
    eMembersId = TextEditingController(text: member.mMembersId);
    booksperMonth = member.mBooksPerMonth;
  }

  @override
  void dispose() {
    eFirstName.dispose();
    eLastName.dispose();
    eAddress.dispose();
    ePhoneNumber.dispose();
    ePinCode.dispose();
    ePlan.dispose();
    eGender.dispose();
    eJoinDate.dispose();
    eExpireDate.dispose();
    eMembersId.dispose();
    super.dispose();
  }

  Future<void> _onUpdate() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final updatedMember = MemberClass(
      eImageEdited,
      eFirstName.text.trim(),
      eLastName.text.trim(),
      eAddress.text.trim(),
      ePinCode.text.trim(),
      ePhoneNumber.text.trim(),
      eGender.text.trim(),
      ePlan.text.trim(),
      eMembersId.text.trim(),
      eJoinDate.text.trim(),
      eExpireDate.text.trim(),
      booksperMonth,
    );

    final error = await ref
        .read(membersListProvider.notifier)
        .updateMember(widget.memberEditDetails, updatedMember);
    if (!mounted) return;

    if (error != null) {
      SnackBarForAll.showError(context, error);
      return;
    }

    SnackBarForAll.showSuccess(context, 'Member updated successfully');
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MemberList()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarForAll(appBarTitle: 'Edit Member Details', navToBorrow: false),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWeb = constraints.maxWidth > 600;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    height: isWeb ? 200 : 150,
                    width: isWeb ? 200 : 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        await MemberUtils.editMemberPickImage(
                          context: context,
                          currentImage: eImageEdited,
                          member: widget.memberEditDetails,
                          repository: ref.read(membersRepositoryProvider),
                          onImageUpdated: (newImage) {
                            setState(() => eImageEdited = newImage);
                          },
                        );
                      },
                      child: eImageEdited != null
                          ? Image.memory(
                              eImageEdited!,
                              fit: BoxFit.cover,
                              height: isWeb ? 200 : 150,
                              width: isWeb ? 200 : 150,
                            )
                          : const Icon(Icons.person, size: 60),
                    ),
                  ),
                  const SizedBox(height: 30),
                  AllTextFormField(
                    controller: eFirstName,
                    validator: (value) => (value == null || value.isEmpty) ? 'Field is empty' : null,
                  ),
                  const SizedBox(height: 10),
                  AllTextFormField(
                    controller: eLastName,
                    validator: (value) => (value == null || value.isEmpty) ? 'Field is empty' : null,
                  ),
                  const SizedBox(height: 10),
                  AllTextFormField(
                    controller: eAddress,
                    validator: (value) => (value == null || value.isEmpty) ? 'Field is empty' : null,
                  ),
                  const SizedBox(height: 10),
                  AllTextFormField(
                    controller: ePinCode,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Field is empty';
                      if (value.length != 6) return 'Pincode must be 6 digits';
                      if (int.tryParse(value) == null) return 'Only numbers are accepted';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  AllTextFormField(
                    controller: ePhoneNumber,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Field is empty';
                      if (value.length != 10) return 'Phone number must be 10 digits';
                      if (int.tryParse(value) == null) return 'Only numbers are accepted';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  AllTextFormField(controller: eGender, readOnly: true),
                  const SizedBox(height: 10),
                  AllTextFormField(
                    controller: ePlan,
                    readOnly: true,
                    onTap: () async {
                      await MemberUtils.editMemberMembershipPlanSelection(
                        context: context,
                        planController: ePlan,
                        joinDateController: eJoinDate,
                        expireDateController: eExpireDate,
                        onCountSelected: (count) {
                          setState(() {
                            booksperMonth = count;
                            paymentSection = true;
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  AllTextFormField(controller: eMembersId, readOnly: true),
                  const SizedBox(height: 10),
                  AllTextFormField(controller: eJoinDate, readOnly: true),
                  const SizedBox(height: 10),
                  AllTextFormField(controller: eExpireDate, readOnly: true),
                  const SizedBox(height: 10),
                  if (paymentCompleted)
                    Row(
                      children: [
                        const Icon(Icons.task_alt_outlined, color: Colors.green, size: 30),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Membership payment is now completed',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      ],
                    ),
                  if (paymentCompleted) const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: isWeb ? const Size(400, 50) : const Size(170, 40),
                              backgroundColor: Colors.black.withValues(alpha: 0.8)),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(color: Colors.red),
                          )),
                      if (paymentSection && !paymentCompleted)
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: isWeb ? const Size(400, 50) : const Size(170, 40),
                                backgroundColor: Colors.black.withValues(alpha: 0.8)),
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
                            fixedSize: isWeb ? const Size(400, 50) : const Size(170, 40),
                            backgroundColor: Colors.red.withValues(alpha: 0.8),
                          ),
                          onPressed: _onUpdate,
                          child: const Text(
                            'Update',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}