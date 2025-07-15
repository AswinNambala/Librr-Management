import 'package:flutter/material.dart';
import 'package:librrr_management/screens/dash%20board/widgets/home_functions.dart';

class ReportContainer extends StatelessWidget {
  final String titleText;
  final String subText;
  final String trailText;
  const ReportContainer(
      {super.key,
      required this.titleText,
      required this.subText,
      required this.trailText});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isWeb = constraints.maxWidth > 600;
      return Container(
        width: isWeb ? 600 : 300,
        height: isWeb ? 130 : 80,
        decoration: BoxDecoration(
          color: Colors.blueGrey[100],
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 6),
              blurRadius: 10,
            ),
          ],
        ),
        child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 1,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  titleText,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  subText,
                  style: const TextStyle(color: Colors.black87, fontSize: 18),
                ),
                trailing: Text(
                  trailText,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              );
            }),
      );
    });
  }
}

class ReportOverviewSection extends StatefulWidget {
  final int? totalBook;
  final int? memberCount;
  final int? availableBook;
  final int? borrowedBookCount;
  final String? totalFineAmount;
  final bool isWeb;
  const ReportOverviewSection(
      {super.key,
      required this.isWeb,
      required this.totalBook,
      required this.memberCount,
      required this.availableBook,
      required this.borrowedBookCount,
      required this.totalFineAmount});

  @override
  State<ReportOverviewSection> createState() => _ReportOverviewSectionState();
}

class _ReportOverviewSectionState extends State<ReportOverviewSection> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: !widget.isWeb
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DashBoardContainer(
                        icon: Icons.library_books_outlined,
                        boxColor: Colors.blue,
                        subHead: 'Total Books',
                        count: widget.totalBook.toString()),
                    DashBoardContainer(
                        icon: Icons.people_sharp,
                        boxColor: Colors.yellow,
                        subHead: 'Members',
                        count: widget.memberCount.toString())
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DashBoardContainer(
                        icon: Icons.book_outlined,
                        boxColor: Colors.orange.withOpacity(0.6),
                        subHead: 'Books \n Borrowed',
                        count: widget.borrowedBookCount.toString()),
                    DashBoardContainer(
                        icon: Icons.account_balance_wallet_rounded,
                        boxColor: Colors.red.withOpacity(0.6),
                        subHead: 'Total Fine',
                        count: widget.totalFineAmount != null
                            ? '₹${widget.totalFineAmount}'
                            : '0')
                  ],
                )
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DashBoardContainer(
                    icon: Icons.library_books_outlined,
                    boxColor: Colors.blue,
                    subHead: 'Total Books',
                    count: widget.totalBook.toString()),
                const SizedBox(
                  width: 40,
                ),
                DashBoardContainer(
                    icon: Icons.people_sharp,
                    boxColor: Colors.yellow,
                    subHead: 'Members',
                    count: widget.memberCount.toString()),
                const SizedBox(
                  width: 40,
                ),
                DashBoardContainer(
                    icon: Icons.book_outlined,
                    boxColor: Colors.orange.withOpacity(0.6),
                    subHead: 'Books \n Borrowed',
                    count: widget.borrowedBookCount.toString()),
                const SizedBox(
                  width: 40,
                ),
                DashBoardContainer(
                    icon: Icons.account_balance_wallet_rounded,
                    boxColor: Colors.red.withOpacity(0.6),
                    subHead: 'Total Fine',
                    count: widget.totalFineAmount != null
                        ? '₹${widget.totalFineAmount}'
                        : '0')
              ],
            ),
    );
  }
}
