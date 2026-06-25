import 'dart:math';

import 'package:flutter/material.dart';

import '../../../ui/ui.dart';

/// A simple "are you the parent" check (basic arithmetic a young child
/// can't easily do) shown before purchases, external links, or the Parent
/// Dashboard, per the no-online/child-safety requirements. Pops `true` if
/// answered correctly, `false`/null otherwise — callers should treat
/// anything but `true` as "not verified."
class ParentalGateScreen extends StatefulWidget {
  const ParentalGateScreen({super.key});

  @override
  State<ParentalGateScreen> createState() => _ParentalGateScreenState();
}

class _ParentalGateScreenState extends State<ParentalGateScreen> {
  late final int _a = 10 + Random().nextInt(40);
  late final int _b = 10 + Random().nextInt(40);
  late final List<int> _choices = _buildChoices();
  String? _error;

  List<int> _buildChoices() {
    final correct = _a + _b;
    final wrongOffsets = [-7, 3, 11]..shuffle();
    final choices = [correct, ...wrongOffsets.map((o) => correct + o)];
    choices.shuffle();
    return choices;
  }

  void _answer(int value) {
    if (value == _a + _b) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _error = 'Not quite — try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quick check for grown-ups')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'What is $_a + $_b?',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final choice in _choices)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: PrimaryButton(
                  label: '$choice',
                  onPressed: () => _answer(choice),
                ),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  _error!,
                  style: const TextStyle(color: AppColors.danger),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
