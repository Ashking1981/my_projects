import 'package:flutter/material.dart';

import '../presentation/parental_gate_screen.dart';

/// Pushes the [ParentalGateScreen] and resolves to whether it was passed.
/// Call this before any purchase, external link, or Parent Dashboard entry.
Future<bool> requireParentalGate(BuildContext context) async {
  final passed = await Navigator.of(context).push<bool>(
    MaterialPageRoute(builder: (_) => const ParentalGateScreen()),
  );
  return passed ?? false;
}
