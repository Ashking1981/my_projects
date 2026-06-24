import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';

/// Shows current level + progress toward the next level.
class XpBar extends StatelessWidget {
  const XpBar({
    super.key,
    required this.level,
    required this.currentXp,
    required this.xpForNextLevel,
  });

  final int level;
  final int currentXp;
  final int xpForNextLevel;

  @override
  Widget build(BuildContext context) {
    final progress =
        xpForNextLevel == 0 ? 0.0 : currentXp / xpForNextLevel;

    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.brandPrimary,
          radius: 16,
          child: Text(
            '$level',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.pill),
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1),
              minHeight: 10,
              backgroundColor: Colors.grey.shade300,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.brandPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
