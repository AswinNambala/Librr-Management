// add borrowed books page select expire date from date picker
   import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:librrr_management/core/const_value.dart';

void borrowedBookExpireDatePicker(
      BuildContext context, TextEditingController expireDate) async {
    DateTime startDate =
        DateTime.now().add(Duration(days: defualtDaysToBorrow));
    DateTime today = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: startDate.subtract(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: Color(0xFF2C5364),
                ),
                textButtonTheme: TextButtonThemeData(
                    style:
                        TextButton.styleFrom(foregroundColor: Colors.white))),
            child: child!);
      },
    );

    if (pickedDate != null) {
      final date = DateFormat('dd-MM-yyyy');
      expireDate.text = date.format(pickedDate);
    }
  }