import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';

/// A speech-bubble line of dialogue from Pixel or a Realm mentor.
/// [mascotAssetPath] is optional Lottie/image asset; falls back to a
/// placeholder avatar with the mascot's initial.
class MascotBubble extends StatelessWidget {
  const MascotBubble({
    super.key,
    required this.speakerName,
    required this.message,
    this.mascotAssetPath,
    this.accentColor = AppColors.brandPrimary,
  });

  final String speakerName;
  final String message;
  final String? mascotAssetPath;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: accentColor,
          child: Text(
            speakerName.isNotEmpty ? speakerName[0] : '?',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppRadii.md),
              border: Border.all(color: accentColor.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  speakerName,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: accentColor),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(message, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
