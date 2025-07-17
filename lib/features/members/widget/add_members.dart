   import 'package:flutter/material.dart';
import 'package:librrr_management/features/members/widget/members_profile_container.dart';
import 'package:librrr_management/features/qr%20code/pages/qr_code.dart';
import 'package:librrr_management/core/helpers/about_test_style.dart';

// add members page select member gender 
Future<void> addMemberSelectGender(
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

  // bottom sheet for add members payment sections
  Future<bool> bottomsheetforPayment(BuildContext context) async {
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

  