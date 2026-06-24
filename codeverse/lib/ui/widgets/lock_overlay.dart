import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';

/// Dims locked content and shows a lock glyph. Tasteful, not punitive —
/// pairs with the paywall's "Unlock the full journey" screen on tap.
class LockOverlay extends StatelessWidget {
  const LockOverlay({super.key, this.borderRadius = 0});

  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        color: AppColors.lockedOverlay,
        alignment: Alignment.center,
        child: const Icon(Icons.lock_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}
