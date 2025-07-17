import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:librrr_management/data/data_sources/local_data/members_db_utils.dart';
import 'package:librrr_management/data/models/members/members_class.dart';
import 'package:librrr_management/features/members/controllers/member_utils.dart';
import 'package:librrr_management/features/members/widget/add_members.dart';
import 'package:librrr_management/core/helpers/all_text_form_field.dart';
import 'package:librrr_management/core/helpers/appbar_for_all.dart';

class EditMemberScreen extends StatefulWidget {
  final MemberClass memberEditDetails;
  final int index;

  const EditMemberScreen({
    super.key,
    required this.memberEditDetails,
    required this.index,
  });

  @override
  State<EditMemberScreen> createState() => _EditMemberScreenState();
}

class _EditMemberScreenState extends State<EditMemberScreen> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarForAll(
        appBarTitle: 'Edit Member Details',
        navToBorrow: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWeb = constraints.maxWidth > 600;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
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
                        memberIndex: widget.index,
                        member: widget.memberEditDetails,
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
                ),
                const SizedBox(height: 10),
                AllTextFormField(
                  controller: eLastName,
                ),
                const SizedBox(height: 10),
                AllTextFormField(
                  controller: eAddress,
                ),
                const SizedBox(height: 10),
                AllTextFormField(
                  controller: ePinCode,
                ),
                const SizedBox(height: 10),
                AllTextFormField(
                  controller: ePhoneNumber,
                ),
                const SizedBox(height: 10),
                AllTextFormField(
                  controller: eGender,
                  readOnly: true,
                  
                ),
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
                      countPerMonth: booksperMonth,
                    );
                    setState(() {
                      paymentSection = true;
                    });
                  },
                ),
                const SizedBox(height: 10),
                AllTextFormField(
                  controller: eMembersId,
                  readOnly: true,
                ),
                const SizedBox(height: 10),
                AllTextFormField(
                  controller: eJoinDate,
                  readOnly: true,
                ),
                const SizedBox(height: 10),
                AllTextFormField(
                  controller: eExpireDate,
                  readOnly: true,
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
                if (paymentCompleted) const SizedBox(height: 20),
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
                    if (paymentSection)
                      if (!paymentCompleted)
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: isWeb
                                    ? const Size(400, 50)
                                    : const Size(170, 40),
                                backgroundColor: Colors.black.withOpacity(0.8)),
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
                        onPressed: () async {
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
                            booksperMonth
                          );

                          await DbMemberUtils.editMemberOnUpdatePressed(
                            context: context,
                            oldMember: widget.memberEditDetails,
                            updatedMember: updatedMember,
                          );
                        },
                        child: const Text(
                          'Update',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
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
}
