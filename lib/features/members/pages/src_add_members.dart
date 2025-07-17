import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:librrr_management/data/data_sources/local_data/members_db_utils.dart';
import 'package:librrr_management/data/models/members/members_class.dart';
import 'package:librrr_management/features/members/controllers/member_utils.dart';
import 'package:librrr_management/features/members/widget/add_members.dart';
import 'package:librrr_management/core/helpers/all_text_form_field.dart';
import 'package:librrr_management/core/helpers/appbar_for_all.dart';

class AddMembersSCreen extends StatefulWidget {
  const AddMembersSCreen({super.key});

  @override
  State<AddMembersSCreen> createState() => _AddMembersSCreenState();
}

class _AddMembersSCreenState extends State<AddMembersSCreen> {
  Uint8List? imageByte;
  final TextEditingController mFirstName = TextEditingController();
  final TextEditingController mLastName = TextEditingController();
  final TextEditingController mAddress = TextEditingController();
  final TextEditingController mPhoneNumber = TextEditingController();
  final TextEditingController mPinCode = TextEditingController();
  final TextEditingController mPlan = TextEditingController();
  final TextEditingController mGender = TextEditingController();
  final TextEditingController mJoinDate = TextEditingController();
  final TextEditingController mExpireDate = TextEditingController();
  final TextEditingController mMembersId = TextEditingController();
  final TextEditingController mNone = TextEditingController();
  String booksPerMonth = '';
  bool paymentCompleted = false;
  bool paymentSection = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarForAll(
        appBarTitle: 'Add Member Details',
        navToBorrow: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWeb = constraints.maxWidth > 600;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  left: isWeb ? 100 : 15,
                  right: isWeb ? 100 : 15,
                  top: isWeb ? 40 : 20,
                  bottom: isWeb ? 40 : 10),
              child: Column(
                children: [
                  Container(
                    width: isWeb ? 200 : 150,
                    height: isWeb ? 200 : 150,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GestureDetector(
                      onTap: () =>
                          MemberUtils.addMemberPickImage(context, (bytes) {
                        setState(() {
                          imageByte = bytes;
                        });
                      }),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          imageByte == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.photo,
                                      size: 50,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Add Photo',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    )
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.memory(
                                    imageByte!,
                                    fit: BoxFit.cover,
                                    height: isWeb ? 200 : 150,
                                    width: isWeb ? 200 : 150,
                                  ))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  AllTextFormField(
                    controller: mFirstName,
                    hint: 'First Name',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Field is empty';
                      } else if (value.length < 3) {
                        return 'At least 3 characters required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  AllTextFormField(
                    controller: mLastName,
                    hint: 'Last Name',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Field is empty';
                      } else if (value.isEmpty) {
                        return 'At least 1 characters required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  AllTextFormField(
                    controller: mAddress,
                    hint: 'Address',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Field is empty';
                      } else if (value.length < 3) {
                        return 'At least 3 characters required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  AllTextFormField(
                    controller: mPinCode,
                    hint: 'Pincode',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Field is empty';
                      } else if (value.length != 6) {
                        return 'Pincode must be 6 digits';
                      } else if (int.tryParse(value) == null) {
                        return 'Only numbers are accepted';
                      } else if (value.length > 6) {
                        return 'Pincode only have 6 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  AllTextFormField(
                    controller: mPhoneNumber,
                    hint: 'Phone Number',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Field is empty';
                      } else if (value.length != 10) {
                        return 'Phone number must be 10 digits';
                      } else if (int.tryParse(value) == null) {
                        return 'Only numbers are accepted';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  AllTextFormField(
                    controller: mGender,
                    hint: 'Gender',
                    readOnly: true,
                    onTap: () =>
                        addMemberSelectGender(context, (gender) {
                      setState(() {
                        mGender.text = gender;
                      });
                    }),
                  ),
                  const SizedBox(height: 15),
                  AllTextFormField(
                    controller: mPlan,
                    hint: 'Click the arrow to select a plan',
                    readOnly: true,
                    onTap: () => MemberUtils.addMemberMembershipPlanSelection(
                      context,
                      (plan, joinDate, expireDate, memberId, count) {
                        setState(() {
                          mPlan.text = plan;
                          mJoinDate.text = joinDate;
                          mExpireDate.text = expireDate;
                          mMembersId.text = memberId;
                          booksPerMonth = count;
                          paymentSection = true;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  AllTextFormField(
                    controller: mMembersId,
                    hint: 'Members id ',
                    readOnly: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AllTextFormField(
                    controller: mJoinDate,
                    hint: 'joining date of member',
                    readOnly: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AllTextFormField(
                    controller: mExpireDate,
                    hint: 'Expire date of membership',
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
                  if (paymentCompleted)
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
                      if (paymentSection)
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
                              fixedSize: isWeb
                                  ? const Size(400, 50)
                                  : const Size(170, 40),
                              backgroundColor: Colors.red.withOpacity(0.8),
                            ),
                            onPressed: () {
                              final newMember = MemberClass(
                                imageByte,
                                mFirstName.text.trim(),
                                mLastName.text.trim(),
                                mAddress.text.trim(),
                                mPinCode.text.trim(),
                                mPhoneNumber.text.trim(),
                                mGender.text.trim(),
                                mPlan.text.trim(),
                                mMembersId.text.trim(),
                                mJoinDate.text.trim(),
                                mExpireDate.text.trim(),
                                booksPerMonth
                              );
                              DbMemberUtils.addMemberMembersOnPress(
                                  context: context, newMember: newMember);
                            },
                            child: const Text(
                              'Save',
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                            )),
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
