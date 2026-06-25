import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';

/// Displays 0–3 stars, e.g. for challenge results on a [LevelNode].
class StarRating extends StatelessWidget {
  const StarRating({super.key, required this.stars, this.size = 16});

  final int stars;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final filled = i < stars;
        return Icon(
          filled ? Icons.star_rounded : Icons.star_outline_rounded,
          color: filled ? AppColors.star : Colors.grey,
          size: size,
        );
      }),
    );
  }
}
