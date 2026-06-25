import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_text_styles.dart';
import 'lock_overlay.dart';

class RealmCard extends StatelessWidget {
  const RealmCard({
    super.key,
    required this.realmId,
    required this.title,
    required this.subtitle,
    required this.progress,
    this.locked = false,
    this.onTap,
  });

  final RealmId realmId;
  final String title;
  final String subtitle;

  /// 0.0–1.0 completion within this Realm.
  final double progress;
  final bool locked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = RealmPalette.of(realmId);

    return Stack(
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          child: InkWell(
            onTap: locked ? null : onTap,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadii.lg),
                gradient: LinearGradient(
                  colors: palette.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.subheading()
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption()
                        .copyWith(color: Colors.white.withOpacity(0.9)),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0, 1),
                      minHeight: 6,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (locked)
          const Positioned.fill(
            child: LockOverlay(borderRadius: AppRadii.lg),
          ),
      ],
    );
  }
}
