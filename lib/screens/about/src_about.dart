import 'package:flutter/material.dart';
import 'package:librrr_management/widgets/about_test_style.dart';
import 'package:librrr_management/widgets/appbar_for_all.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarForAll(
        appBarTitle: 'About',
        navToBorrow: false,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > 600;
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: isWeb ? 200 : 120,
                    width: isWeb ? 200 : 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(2, 6),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/logo for librr1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AboutTestStyle(
                    text: 'Librr Management',
                    styleText: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  AboutTestStyle(
                    text: 'Version 2.1.2',
                    styleText: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AboutTestStyle(
                        text: 'About the App',
                        styleText: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AboutTestStyle(
                        text:
                            'This app helps manage library books, members, and borrowing activities.'
                            'You can track available books, borrowed books, late returns, and member details easily in one place.',
                        styleText: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: isWeb? MainAxisAlignment.start : MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AboutTestStyle(
                                text: 'Key Features',
                                styleText:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              AboutTestStyle(
                                text: '- Add, edit, delete books and members',
                                styleText:
                                    Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              AboutTestStyle(
                                text: '- Record borrow and return dates',
                                styleText:
                                    Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              AboutTestStyle(
                                text: '- View available and borrowed books',
                                styleText:
                                    Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              AboutTestStyle(
                                text: '- Works offline without internet',
                                styleText:
                                    Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              AboutTestStyle(
                                text: '- Built using Flutter and Hive.',
                                styleText:
                                    Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              AboutTestStyle(
                                text: 'Developer Info',
                                styleText:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              AboutTestStyle(
                                text: 'Developed By : Aswin Nambala',
                                styleText: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              AboutTestStyle(
                                text: 'Email ID : uanachu8271@gmail.com',
                                styleText:
                                    Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      AboutTestStyle(
                        text: 'Privacy',
                        styleText: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AboutTestStyle(
                        text:
                            'This app keeps your data private by storing it only on your device.',
                        styleText: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: isWeb? MainAxisAlignment.start : MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AboutTestStyle(
                                text: 'Payment Details',
                                styleText:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SelectableText(
                                'UPI ID : 9633173658@superyes',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              AboutTestStyle(
                                text: 'Bank Name : Federal Bank',
                                styleText:
                                    Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              AboutTestStyle(
                                text: 'Bank Account Number : 111901154778',
                                styleText:
                                    Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              AboutTestStyle(
                                text: 'IFSC : FDRL0001119',
                                styleText:
                                    Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
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
