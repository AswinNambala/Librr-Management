import 'package:flutter/material.dart';

class QuickContainer extends StatelessWidget {
  final IconData icon;
  final String subHead;
  final Color? boxColor;
  final GestureTapCallback navigate;

  const QuickContainer({
    super.key,
    required this.icon,
    required this.boxColor,
    required this.subHead,
    required this.navigate,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: navigate,
      borderRadius: BorderRadius.circular(20),
      splashColor: Colors.deepPurple.withOpacity(0.2),
      child: Container(
        height: 150,
        width: 180,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
          boxColor!.withOpacity(0.2) , boxColor!.withOpacity(0.25)
        ]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 6),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                icon,
                size: 30,
                color: boxColor,
              ),
            const SizedBox(height: 12),
            Text(
              subHead,
             style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: boxColor),
            ),
          ],
        ),
      ),
    );
  }
}
