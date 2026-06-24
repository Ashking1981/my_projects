import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';
import 'lock_overlay.dart';
import 'star_rating.dart';

enum LevelNodeStatus { locked, unlocked, completed }

class LevelNode extends StatelessWidget {
  const LevelNode({
    super.key,
    required this.label,
    required this.status,
    required this.realmId,
    this.stars = 0,
    this.isBoss = false,
    this.onTap,
  });

  final String label;
  final LevelNodeStatus status;
  final RealmId realmId;
  final int stars;
  final bool isBoss;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = RealmPalette.of(realmId);
    final isLocked = status == LevelNodeStatus.locked;
    final size = isBoss ? 72.0 : 56.0;

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: status == LevelNodeStatus.locked
                      ? Colors.grey.shade300
                      : palette.accent,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                alignment: Alignment.center,
                child: Icon(
                  isBoss ? Icons.shield_rounded : Icons.flag_rounded,
                  color: Colors.white,
                  size: isBoss ? 32 : 24,
                ),
              ),
              if (isLocked)
                LockOverlay(borderRadius: size / 2),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          if (status == LevelNodeStatus.completed)
            StarRating(stars: stars),
        ],
      ),
    );
  }
}
