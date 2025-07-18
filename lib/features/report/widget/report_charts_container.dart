import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:librrr_management/features/report/controllers/report_utils.dart';
import 'package:librrr_management/data/models/borrowed_books/borrowed_book_class.dart';
import 'package:librrr_management/core/helpers/about_test_style.dart';

// report page borrowed books monthly chart sections
class ReportBorrowMonthlyChart extends StatefulWidget {
  final bool isWeb;
  const ReportBorrowMonthlyChart({super.key, required this.isWeb});

  @override
  State<ReportBorrowMonthlyChart> createState() => _ReportBorrowChartState();
}

class _ReportBorrowChartState extends State<ReportBorrowMonthlyChart> {
  late List<FlSpot> monthlyData;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final box = Hive.box<BorrowedBookClass>('borrowedBooks');
    monthlyData = ReportUtils.borrowedBooksMonthlyData(box, context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.isWeb? 500 : 400,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.show_chart_rounded,
                color: Colors.red,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              AboutTestStyle(
                text: 'Monthly Borrowing Trends',
                styleText: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              height: widget.isWeb? 400 : 300,
              width: widget.isWeb ? 1300 : 800,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 5, left: 10, right: 15, bottom: 5),
                child: LineChart(LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1,
                      getDrawingHorizontalLine: (value) => const FlLine(
                        color: Colors.white,
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                reservedSize: 30,
                                getTitlesWidget: (value, meta) {
                                  const months = [
                                    'Jan',
                                    'Feb',
                                    'Mar',
                                    'Apr',
                                    'May',
                                    'Jun',
                                    'Jul',
                                    'Aug',
                                    'Sep',
                                    'Oct',
                                    'Nov',
                                    'Dec'
                                  ];
                                  if (value >= 0 && value < months.length) {
                                    return SideTitleWidget(
                                      space: 8,
                                      axisSide: meta.axisSide,
                                      child: Text(
                                        months[value.toInt()],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                })),
                        leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            return SideTitleWidget(
                              space: 8,
                              axisSide: meta.axisSide,
                              child: Text(
                                value.toInt().toString(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            );
                          },
                        ))),
                    borderData: FlBorderData(
                      show: true,
                    ),
                    minX: 0,
                    maxX: 11,
                    minY: 0,
                    maxY: monthlyData
                            .map((e) => e.y)
                            .reduce((a, b) => a > b ? a : b) +
                        4,
                    lineBarsData: [
                      LineChartBarData(
                          spots: monthlyData,
                          isCurved: true,
                          color: Theme.of(context).colorScheme.secondary,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spots, percentage, barData, index) {
                              return FlDotCirclePainter(
                                  radius: 4,
                                  color: Theme.of(context).colorScheme.primary,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white);
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.1),
                          ))
                    ])),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.circle,
                color: Colors.red,
                size: 15,
              ),
              const SizedBox(
                width: 10,
              ),
              AboutTestStyle(
                text: 'Books Borrowed',
                styleText: Theme.of(context).textTheme.bodyMedium,
              )
            ],
          )
        ],
      ),
    );
  }
}

// report page borrowed books weekly chart sections
class ReportBorrowWeeklyChart extends StatefulWidget {
  final bool isWeb;
  const ReportBorrowWeeklyChart({super.key, required this.isWeb});

  @override
  State<ReportBorrowWeeklyChart> createState() =>
      _ReportBorrowWeeklyChartState();
}

class _ReportBorrowWeeklyChartState extends State<ReportBorrowWeeklyChart> {
  late List<FlSpot> weeklyData;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final box = Hive.box<BorrowedBookClass>('borrowedBooks');
    weeklyData = ReportUtils.borrowedBooksWeeklyData(box, context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.isWeb? 500 : 400,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.bar_chart_outlined,
                color: Colors.red,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              AboutTestStyle(
                text: 'Weekly Activity',
                styleText: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: widget.isWeb ? 1300 : 600,
              height: widget.isWeb? 400 : 300,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 5, left: 10, right: 15, bottom: 5),
                child: LineChart(LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1,
                      getDrawingHorizontalLine: (value) => const FlLine(
                        color: Colors.white,
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                reservedSize: 30,
                                getTitlesWidget: (value, meta) {
                                  const weeks = [
                                    'Mon',
                                    'Tue',
                                    'Wed',
                                    'Thu',
                                    'Fri',
                                    'Sat',
                                    'Sun',
                                  ];
                                  if (value >= 0 && value < weeks.length) {
                                    return SideTitleWidget(
                                      space: 8,
                                      axisSide: meta.axisSide,
                                      child: Text(
                                        weeks[value.toInt()],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                })),
                        leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            return SideTitleWidget(
                              space: 8,
                              axisSide: meta.axisSide,
                              child: Text(
                                value.toInt().toString(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            );
                          },
                        ))),
                    borderData: FlBorderData(
                      show: true,
                    ),
                    minX: 0,
                    maxX: 6,
                    minY: 0,
                    maxY: weeklyData
                            .map((e) => e.y)
                            .reduce((a, b) => a > b ? a : b) +
                        4,
                    lineBarsData: [
                      LineChartBarData(
                          spots: weeklyData,
                          isCurved: true,
                          color: Theme.of(context).colorScheme.secondary,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spots, percentage, barData, index) {
                              return FlDotCirclePainter(
                                  radius: 4,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white);
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.3),
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ))
                    ])),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.circle,
                color: Colors.red,
                size: 15,
              ),
              const SizedBox(
                width: 10,
              ),
              AboutTestStyle(
                text: 'Books Borrowed',
                styleText: Theme.of(context).textTheme.bodyMedium,
              )
            ],
          )
        ],
      ),
    );
  }
}

// report page books categories distribution chart sections
class ReportAllBooksChart extends StatefulWidget {
  final bool isWeb;
  const ReportAllBooksChart({super.key, required this.isWeb});

  @override
  State<ReportAllBooksChart> createState() => _ReportAllBooksChartState();
}

class _ReportAllBooksChartState extends State<ReportAllBooksChart> {
  List<String> genreList = [
    'Supernatural',
    'Romance',
    'Travel',
    'Personal Development',
    'Comedy',
    'Other'
  ];

  List<PieChartSectionData> genreData = [];
  Map<String, int> genreCount = {};

  @override
  void initState() {
    super.initState();
    loadingData();
  }

  void loadingData() {
    genreCount = ReportUtils.reportFliterBooksGenre(genreList);

    genreData = genreCount.entries
        .where((entry) => entry.value > 0) 
        .map((entry) {
      int index = genreList.indexOf(entry.key);
      return PieChartSectionData(
        value: entry.value.toDouble(),
        title: '${entry.value}',
        color: ReportUtils.colorList[index],
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 550,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.pie_chart,
                color: Colors.yellow,
                size: 30,
              ),
              const SizedBox(width: 10),
              AboutTestStyle(
                text: 'Books Categories Distribution',
                styleText: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: widget.isWeb ? double.infinity : 450,
            height: 300,
            child: Center(
              child: genreData.isEmpty
                  ? const CircularProgressIndicator()
                  : Directionality(
                      textDirection: TextDirection.ltr,
                      child: PieChart(
                        PieChartData(
                          sections: genreData,
                          centerSpaceRadius: 50,
                          sectionsSpace: 3,
                          borderData: FlBorderData(show: false),
                          pieTouchData: PieTouchData(enabled: false),
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          _buildLegend(context),
        ],
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.bodyMedium;
    return Column(
      children: [
        Row(
          children: [
            _buildLegendItem(0, 'Supernatural', textStyle),
            const SizedBox(width: 20),
            _buildLegendItem(1, 'Romance', textStyle),
            const SizedBox(width: 20),
            _buildLegendItem(2, 'Travel', textStyle),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _buildLegendItem(3, 'Personal Development', textStyle),
            const SizedBox(width: 20),
            _buildLegendItem(4, 'Comedy', textStyle),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _buildLegendItem(5, 'Other', textStyle),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(int index, String label, TextStyle? style) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          color: ReportUtils.colorList[index],
          size: 15,
        ),
        const SizedBox(width: 10),
        AboutTestStyle(
          text: label,
          styleText: style,
        ),
      ],
    );
  }
}