import 'dart:math';

import 'package:flutter/material.dart';

import '../../../data/models/challenge.dart';
import '../../../ui/ui.dart';

/// Renders the right input control for a [Challenge] and reports the
/// player's in-progress response on every change via [onChanged]. The
/// shape of that response matches what each [Challenge.isCorrect] expects.
class ChallengeAnswerWidget extends StatefulWidget {
  const ChallengeAnswerWidget({
    super.key,
    required this.challenge,
    required this.onChanged,
  });

  final Challenge challenge;
  final ValueChanged<Object?> onChanged;

  @override
  State<ChallengeAnswerWidget> createState() => _ChallengeAnswerWidgetState();
}

class _ChallengeAnswerWidgetState extends State<ChallengeAnswerWidget> {
  int? _selectedIndex;
  String _typedAnswer = '';
  late List<String> _availableItems;
  final List<String> _chosenOrder = [];
  late Map<String, String?> _selectedMatches;
  late Map<String, List<String>> _matchOptionsByKey;

  @override
  void initState() {
    super.initState();
    final challenge = widget.challenge;
    switch (challenge) {
      case DragToOrderChallenge():
        _availableItems = [...challenge.correctOrder]..shuffle(Random(0));
      case BlockCodeChallenge():
        _availableItems = [
          ...challenge.correctBlocks,
          ...challenge.distractorBlocks,
        ]..shuffle(Random(0));
      case MatchPairsChallenge():
        _selectedMatches = {for (final key in challenge.pairs.keys) key: null};
        final shuffledValues = [...challenge.pairs.values]..shuffle(Random(0));
        _matchOptionsByKey = {
          for (final key in challenge.pairs.keys) key: shuffledValues,
        };
      case MultipleChoiceChallenge():
      case FillBlankChallenge():
        break;
    }
  }

  void _pickItem(String item) {
    setState(() {
      _availableItems.remove(item);
      _chosenOrder.add(item);
    });
    widget.onChanged(List<String>.from(_chosenOrder));
  }

  void _unpickItem(String item) {
    setState(() {
      _chosenOrder.remove(item);
      _availableItems.add(item);
    });
    widget.onChanged(List<String>.from(_chosenOrder));
  }

  @override
  Widget build(BuildContext context) {
    final challenge = widget.challenge;
    return switch (challenge) {
      MultipleChoiceChallenge() => _buildMultipleChoice(challenge),
      FillBlankChallenge() => _buildFillBlank(challenge),
      DragToOrderChallenge() => _buildOrderable(),
      BlockCodeChallenge() => _buildOrderable(),
      MatchPairsChallenge() => _buildMatchPairs(challenge),
    };
  }

  Widget _buildMultipleChoice(MultipleChoiceChallenge challenge) {
    return ListView(
      children: [
        for (var i = 0; i < challenge.options.length; i++)
          RadioListTile<int>(
            title: Text(challenge.options[i]),
            value: i,
            groupValue: _selectedIndex,
            onChanged: (value) {
              setState(() => _selectedIndex = value);
              widget.onChanged(value);
            },
          ),
      ],
    );
  }

  Widget _buildFillBlank(FillBlankChallenge challenge) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          challenge.template,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontFamily: 'monospace'),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          decoration: const InputDecoration(hintText: 'Type your answer'),
          onChanged: (value) {
            _typedAnswer = value;
            widget.onChanged(_typedAnswer);
          },
        ),
      ],
    );
  }

  Widget _buildOrderable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your answer:', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final item in _chosenOrder)
              ActionChip(label: Text(item), onPressed: () => _unpickItem(item)),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Available:', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final item in _availableItems)
              ActionChip(label: Text(item), onPressed: () => _pickItem(item)),
          ],
        ),
      ],
    );
  }

  Widget _buildMatchPairs(MatchPairsChallenge challenge) {
    return ListView(
      children: [
        for (final key in challenge.pairs.keys)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              children: [
                Expanded(child: Text(key)),
                const SizedBox(width: AppSpacing.sm),
                DropdownButton<String>(
                  value: _selectedMatches[key],
                  hint: const Text('Choose'),
                  items: [
                    for (final value in _matchOptionsByKey[key]!)
                      DropdownMenuItem(value: value, child: Text(value)),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedMatches[key] = value);
                    if (_selectedMatches.values.every((v) => v != null)) {
                      widget.onChanged(
                        _selectedMatches.map((k, v) => MapEntry(k, v!)),
                      );
                    } else {
                      widget.onChanged(null);
                    }
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
