import 'package:flutter/material.dart';

class StepHeader extends StatelessWidget {
  const StepHeader({
    required this.textTheme,
    required this.title,
    required this.subtitle,
    super.key,
  });

  final TextTheme textTheme;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
            height: 1.35,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
