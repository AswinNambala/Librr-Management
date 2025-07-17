import 'package:flutter/material.dart';

class DashBoardContainer extends StatelessWidget {
  final IconData icon;
  final String subHead;
  final Color? boxColor;
  final String count;

  const DashBoardContainer({
    super.key,
    required this.icon,
    required this.boxColor,
    required this.subHead,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 180,
      padding: const EdgeInsets.only(top: 15, right: 15, left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [boxColor!.withOpacity(0.2), boxColor!.withOpacity(0.25)]),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2, 6),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 30,
                color: boxColor,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                subHead,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: boxColor),
              )
            ],
          ),
          Text(
            count,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}


// shimmer effect

class ShimmerDashBoardContainer extends StatelessWidget {
  const ShimmerDashBoardContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
