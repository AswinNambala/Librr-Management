import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:librrr_management/models/books/books%20_class.dart';
import 'package:librrr_management/models/members/members_class.dart';
import 'package:librrr_management/screens/books/src_book_profile.dart';
import 'package:librrr_management/screens/members/src_membership_plan.dart';
import 'package:librrr_management/screens/members/widget/members_profile_container.dart';
import 'package:librrr_management/screens/qr%20code/qr_code.dart';
import 'package:librrr_management/utilities/const_value.dart';
import 'package:librrr_management/widgets/about_test_style.dart';
import 'package:librrr_management/widgets/snackbar_for_all.dart';

class MemberUtils {
  // every functions needed for add members
  static DateTime addMemberAddMonths(DateTime originalDate, int monthsToAdd) {
    int newYear = originalDate.year;
    int newMonth = originalDate.month + monthsToAdd;

    while (newMonth > 12) {
      newMonth -= 12;
      newYear += 1;
    }

    int newDay = originalDate.day;
    int lastDayOfNewMonth = DateTime(newYear, newMonth + 1, 0).day;
    if (newDay > lastDayOfNewMonth) {
      newDay = lastDayOfNewMonth;
    }

    return DateTime(newYear, newMonth, newDay);
  }

// add members page select image from the gallery
  static Future<void> addMemberPickImage(
      BuildContext context, Function(Uint8List?) onPicked) async {
    final image = ImagePicker();
    final pickedFile = await image.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final byte = await pickedFile.readAsBytes();
      onPicked(byte);
      SnackBarForAll.showSuccess(context, 'Image added successfully');
    } else {
      SnackBarForAll.showError(context, 'Failed to add image');
    }
  }

// add members page select member gender 
  static Future<void> addMemberSelectGender(
      BuildContext context, Function(String) onSelected) async {
    final selectedGender = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
              title: Text(
                'Male',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () => Navigator.pop(context, 'Male')),
          ListTile(
              title: Text(
                'Female',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () => Navigator.pop(context, 'Female')),
          ListTile(
              title: Text(
                'Other',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () => Navigator.pop(context, 'Other')),
        ],
      ),
    );
    if (selectedGender != null) {
      onSelected(selectedGender);
    }
  }

// add members page select plan for members 
  static Future<void> addMemberMembershipPlanSelection(
      BuildContext context,
      Function(String plan, String joinDate, String expireDate, String memberId,
              String countPerMonth)
          onPlanSelected) async {
    final selectedItem = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, ani1, ani2) => const MembershipPlan(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
    String bookCount = '';
    if (selectedItem != null) {
      final now = DateTime.now();
      final formatter = DateFormat('dd-MM-yyyy');
      DateTime expireDate;

      switch (selectedItem) {
        case 'Base Plan':
          expireDate = addMemberAddMonths(now, 1);
          bookCount = basePlanBookCount.toString();
          break;
        case 'Standard Plan':
          expireDate = addMemberAddMonths(now, 3);
          bookCount = standardPlanBookCount.toString();
          break;
        case 'Premium Plan':
          expireDate = addMemberAddMonths(now, 6);
          bookCount = maximumBookCount.toString();
          break;
        case 'Elite Plan':
          expireDate = addMemberAddMonths(now, 12);
          bookCount = maximumBookCount.toString();
          break;
        default:
          expireDate = now;
      }

      final String memberId = 'LB${100000 + Random().nextInt(9999)}';
      onPlanSelected(
        selectedItem,
        formatter.format(now),
        formatter.format(expireDate),
        memberId,
        bookCount,
      );
    }
  }

 
// every function related to edit members page

// edit members page update members plan 
  static Future<void> editMemberMembershipPlanSelection({
    required BuildContext context,
    required TextEditingController planController,
    required TextEditingController joinDateController,
    required TextEditingController expireDateController,
    required countPerMonth,
  }) async {
    final selectedItem = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MembershipPlan()),
    );
    String count = '';

    if (selectedItem != null) {
      planController.text = selectedItem;

      final DateTime now = DateTime.now();
      final formatter = DateFormat('dd-MM-yyyy');
      joinDateController.text = formatter.format(now);
      late DateTime expireDate;

      switch (selectedItem) {
        case 'Base Plan':
          expireDate = editMemberAddMonths(now, 1);
          count = basePlanBookCount.toString();
          break;
        case 'Standard Plan':
          expireDate = editMemberAddMonths(now, 3);
          count = standardPlanBookCount.toString();
          break;
        case 'Premium Plan':
          expireDate = editMemberAddMonths(now, 6);
          count = maximumBookCount.toString();
          break;
        case 'Elite Plan':
          expireDate = editMemberAddMonths(now, 12);
          count = maximumBookCount.toString();
          break;
        default:
          expireDate = now;
      }
      expireDateController.text = formatter.format(expireDate);
      countPerMonth = count;
    }
  }

// edit member page calculate the expire date of membership plan
  static DateTime editMemberAddMonths(DateTime originalDate, int monthsToAdd) {
    int newYear = originalDate.year;
    int newMonth = originalDate.month + monthsToAdd;
    while (newMonth > 12) {
      newMonth -= 12;
      newYear += 1;
    }

    int newDay = originalDate.day;
    int lastDayOfNewMonth = DateTime(newYear, newMonth + 1, 0).day;
    if (newDay > lastDayOfNewMonth) {
      newDay = lastDayOfNewMonth;
    }
    return DateTime(newYear, newMonth, newDay);
  }

// edit member page select image to change from gallery
  static Future<void> editMemberPickImage({
    required BuildContext context,
    required Uint8List? currentImage,
    required int memberIndex,
    required MemberClass member,
    required Function(Uint8List?) onImageUpdated,
  }) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Options'),
        actions: [
          if (currentImage == null)
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Add'),
            ),
          if (currentImage != null)
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Edit'),
            ),
          if (currentImage != null)
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );

    if (shouldDelete == true) {
      final box = Hive.box<MemberClass>('members');
      member.profileImage = null;
      await box.put(memberIndex, member);
      onImageUpdated(null);
    } else {
      final image = ImagePicker();
      final pickedFile = await image.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final byte = await pickedFile.readAsBytes();
        member.profileImage = byte;
        onImageUpdated(byte);
        SnackBarForAll.showSuccess(context, 'Image updated');
      }
    }
  }

  // every functions for member profile

// bottom sheet for add members payment sections
  static Future<bool> bottomsheetforPayment(BuildContext context) async {
    bool returnValue = false;
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: Theme.of(context).colorScheme.onTertiary,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Choose Payment Method',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 25),
              InkWell(
                onTap: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Is the cash received?',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('No',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('Yes',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                      ],
                    ),
                  );
                  if (result == true) {
                    returnValue = true;
                  }
                  Navigator.pop(context); 
                },
                child: buildPaymentOptionButton(context, 'Cash On Delivery'),
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: () {
                  returnValue = true;
                  Navigator.pop(context); 
                  navigateTo(const QrCodeScreen(), context); 
                },
                child: buildPaymentOptionButton(context, 'QR Code'),
              ),
            ],
          ),
        );
      },
    );

    return returnValue;
  }

// navigate to books profile page function
  static void membersOpenBooksProfile(String bookId, BuildContext context) {
    final box = Hive.box<BooksClass>('booksDetials');
    final int index =
        box.values.toList().indexWhere((book) => book.bookShelf == bookId);
    if (index != -1) {
      final BooksClass selectedBook = box.getAt(index)!;
      navigateTo(
          BooksProfileScreen(bookInfo: selectedBook, index: index), context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book not found')),
      );
    }
  }
}
