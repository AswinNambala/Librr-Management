import 'package:flutter/material.dart';
import 'package:librrr_management/features/dash%20board/pages/mobile%20screen/mobile_src_dash_board.dart';
import 'package:librrr_management/features/dash%20board/pages/web%20screen/web_src_dashboard.dart';
import 'package:librrr_management/features/dash%20board/widgets/home_functions.dart';
import 'package:shimmer/shimmer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        highlightColor: Colors.black12,
        direction: ShimmerDirection.ltr,
        period: const Duration(seconds: 2),
        loop: 4,
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWeb = constraints.maxWidth > 600;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Future.delayed(const Duration(seconds: 3), () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => isWeb
                        ? const WebDashboardScreen()
                        : const MobileHomeScreen(),
                  ),
                );
              });
            });
   
            return isWeb
                ? const Wrap(
                    spacing: 15,
                    runSpacing: 10,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 50,
                          ),
                          ShimmerDashBoardContainer(),
                          SizedBox(
                            width: 15,
                          ),
                          ShimmerDashBoardContainer(),
                          SizedBox(
                            width: 15,
                          ),
                          ShimmerDashBoardContainer(),
                          SizedBox(
                            width: 15,
                          ),
                          ShimmerDashBoardContainer()
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 50,
                          ),
                          ShimmerDashBoardContainer(),
                          SizedBox(
                            width: 15,
                          ),
                          ShimmerDashBoardContainer(),
                          SizedBox(
                            width: 15,
                          ),
                          ShimmerDashBoardContainer(),
                          SizedBox(
                            width: 15,
                          ),
                          ShimmerDashBoardContainer()
                        ],
                      ),
                    ],
                  )
                : const Center(
                    child: Wrap(
                      spacing: 15,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            ShimmerDashBoardContainer(),
                            SizedBox(
                              width: 15,
                            ),
                            ShimmerDashBoardContainer()
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            ShimmerDashBoardContainer(),
                            SizedBox(
                              width: 15,
                            ),
                            ShimmerDashBoardContainer()
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            ShimmerDashBoardContainer(),
                            SizedBox(
                              width: 15,
                            ),
                            ShimmerDashBoardContainer()
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            ShimmerDashBoardContainer(),
                            SizedBox(
                              width: 15,
                            ),
                            ShimmerDashBoardContainer()
                          ],
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
