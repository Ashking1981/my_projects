import 'package:flutter/material.dart';

import '../tokens/app_spacing.dart';
import 'primary_button.dart';

/// Common chrome around any challenge variant (multiple-choice,
/// drag-to-order, fill-blank, match-pairs, block-code): a prompt, the
/// variant-specific [content], and a submit action.
class ChallengeShell extends StatelessWidget {
  const ChallengeShell({
    super.key,
    required this.prompt,
    required this.content,
    required this.onSubmit,
    this.canSubmit = true,
    this.isBoss = false,
  });

  final String prompt;
  final Widget content;
  final VoidCallback onSubmit;
  final bool canSubmit;
  final bool isBoss;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isBoss)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                const Icon(Icons.shield_rounded, color: Colors.amber),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Boss Challenge',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
        Text(prompt, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.md),
        Expanded(child: content),
        const SizedBox(height: AppSpacing.md),
        PrimaryButton(
          label: 'Check Answer',
          onPressed: canSubmit ? onSubmit : null,
        ),
      ],
    );
  }
}
