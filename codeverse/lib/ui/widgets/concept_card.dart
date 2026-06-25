import 'package:flutter/material.dart';

import '../tokens/app_spacing.dart';

/// A scannable summary of theory just taught in the Story Scene:
/// a title, a short explanation, and an optional worked example.
class ConceptCard extends StatelessWidget {
  const ConceptCard({
    super.key,
    required this.title,
    required this.explanation,
    this.example,
  });

  final String title;
  final String explanation;
  final String? example;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(explanation, style: Theme.of(context).textTheme.bodyMedium),
            if (example != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                ),
                child: Text(
                  example!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
