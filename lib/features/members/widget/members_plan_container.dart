import 'package:flutter/material.dart';

class PlanContainer extends StatelessWidget {
  final String planHead;
  final String planPrice;
  final String planDetails1;
  final String planDetails2;
  final String planDetails3;
  final IconData? planIcons;

  const PlanContainer({
    required this.planHead,
    required this.planPrice,
    this.planIcons,
    required this.planDetails1,
    required this.planDetails2,
    required this.planDetails3,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, 
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.9),
            Theme.of(context).colorScheme.error.withValues(alpha: 0.8)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (planIcons != null)
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          planIcons,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        planHead,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  planPrice,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          _PlanDetailRow(text: planDetails1),
          const SizedBox(height: 8),
          _PlanDetailRow(text: planDetails2),
          const SizedBox(height: 8),
          _PlanDetailRow(text: planDetails3),
        ],
      ),
    );
  }
}

class _PlanDetailRow extends StatelessWidget {
  final String text;
  const _PlanDetailRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, color: Colors.white70, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}