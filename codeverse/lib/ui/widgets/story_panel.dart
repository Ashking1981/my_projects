import 'package:flutter/material.dart';

import '../tokens/app_spacing.dart';
import 'mascot_bubble.dart';

/// One swipeable panel of a Story Scene: a single line of dialogue.
class StoryPanel extends StatelessWidget {
  const StoryPanel({
    super.key,
    required this.speakerName,
    required this.message,
    this.mascotAssetPath,
    this.backgroundAssetPath,
  });

  final String speakerName;
  final String message;
  final String? mascotAssetPath;
  final String? backgroundAssetPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Spacer(),
          MascotBubble(
            speakerName: speakerName,
            message: message,
            mascotAssetPath: mascotAssetPath,
          ),
        ],
      ),
    );
  }
}
