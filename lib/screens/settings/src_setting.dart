import 'package:flutter/material.dart';
import 'package:librrr_management/utilities/const_value.dart';
import 'package:librrr_management/widgets/about_test_style.dart';
import 'package:librrr_management/widgets/appbar_for_all.dart';
import 'package:librrr_management/screens/about/src_about.dart';
import 'package:librrr_management/screens/report/src_report.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int currentValue = defualtDaysToBorrow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarForAll(
        appBarTitle: 'Settings',
        navToBorrow: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AboutTestStyle(
                text: 'Borrow Book Period',
                styleText: Theme.of(context).textTheme.bodyLarge,
              ),
              DropdownButton<int>(
                value: currentValue,
                borderRadius: BorderRadius.circular(10),
                dropdownColor: Colors.black,
                items: List.generate(
                  25,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('${index + 1} days'),
                  ),
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      defualtDaysToBorrow = value;
                      currentValue = value;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(thickness: 1.2),
          const SizedBox(
            height: 10,
          ),
          
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: AboutTestStyle(
              text: 'About',
              styleText: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              navigateTo(const AboutScreen(), context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: AboutTestStyle(
              text: 'Report',
              styleText: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              navigateTo(const ReportScreen(), context);
            },
          ),
        ],
      ),
    );
  }
}
