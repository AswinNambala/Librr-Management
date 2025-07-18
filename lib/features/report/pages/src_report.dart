import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:librrr_management/features/report/controllers/report_utils.dart';
import 'package:librrr_management/data/models/books/books%20_class.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/data/models/members/members_class.dart';
import 'package:librrr_management/features/report/widget/report_container.dart';
import 'package:librrr_management/features/settings/page/src_setting.dart';
import 'package:librrr_management/core/helpers/about_test_style.dart';
import 'package:librrr_management/core/helpers/appbar_for_all.dart';
import 'package:librrr_management/features/report/widget/report_charts_container.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int? totalBook;
  int? memberCount;
  int? availableBook;
  int? borrowedBookCount;
  String? totalFineAmount;

  @override
  void initState() {
    super.initState();
    loading();
  }

  void loading() {
    final bookBox = Hive.box<BooksClass>('booksDetials');
    final borrowedBox = Hive.box<BorrowedBookClass>('borrowedBooks');
    final memberBox = Hive.box<MemberClass>('members');
    final int borrowedBook = borrowedBox.length;
    final int bookLength = bookBox.values.fold(
      0,
      (sum, element) {
        return sum + int.parse(element.numberOfBooks);
      },
    );
    setState(() {
      totalBook = bookLength;
      availableBook =
          borrowedBook == 0 ? bookLength : (bookLength - borrowedBook);
      memberCount = memberBox.length;
      borrowedBookCount = borrowedBook;
    });
    totalFineAmount = ReportUtils.fineAmountCalculate(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const AppBarForAll(
          appBarTitle: 'Report',
          navToBorrow: false,
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          bool isWeb = constraints.maxWidth > 900;
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.tertiary.withOpacity(0.05),
                  Theme.of(context).colorScheme.surface,
                ],
              ),
            ),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AboutTestStyle(
                          text: 'Library Report',
                          styleText: Theme.of(context).textTheme.headlineMedium,
                        ),
                        IconButton(
                            onPressed: () {
                              navigateTo(const SettingScreen(), context);
                            },
                            icon: Icon(
                              Icons.settings,
                              color: Theme.of(context).colorScheme.onSurface,
                              size: 30,
                            ))
                      ],
                    ),
                    AboutTestStyle(
                      text:
                          'Analytics and insights for ${DateFormat('MMMM d').format(DateTime.now())}',
                      styleText: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AboutTestStyle(
                      text: 'Overview',
                      styleText: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ReportOverviewSection(
                        isWeb: isWeb,
                        totalBook: totalBook ?? 0,
                        memberCount: memberCount ?? 0,
                        availableBook: availableBook ?? 0,
                        borrowedBookCount: borrowedBookCount ?? 0,
                        totalFineAmount: totalFineAmount ?? "0"),
                    const SizedBox(
                      height: 30,
                    ),
                    ReportBorrowMonthlyChart(
                      isWeb: isWeb,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ReportBorrowWeeklyChart(
                      isWeb: isWeb,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ReportAllBooksChart(isWeb: isWeb)
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
