import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers.dart';
import '../../../ui/ui.dart';
import '../../parent/application/parental_gate.dart';

/// "Unlock the full journey" pitch shown whenever the player taps a PRO
/// Realm. Purchases always go through the Parental Gate first.
class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  bool _busy = false;
  String? _message;

  Future<void> _buy() async {
    final passed = await requireParentalGate(context);
    if (!passed || !mounted) return;

    setState(() {
      _busy = true;
      _message = null;
    });
    final success = await ref.read(entitlementProvider.notifier).purchasePro();
    if (!mounted) return;
    setState(() {
      _busy = false;
      _message = success
          ? 'PRO unlocked — enjoy the rest of the journey!'
          : "Purchase didn't go through. Please try again.";
    });
    if (success) Navigator.of(context).pop();
  }

  Future<void> _restore() async {
    final passed = await requireParentalGate(context);
    if (!passed || !mounted) return;

    setState(() {
      _busy = true;
      _message = null;
    });
    final restored =
        await ref.read(entitlementProvider.notifier).restorePurchases();
    if (!mounted) return;
    setState(() {
      _busy = false;
      _message =
          restored ? 'Purchase restored!' : 'No previous purchase found.';
    });
    if (restored) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unlock PRO')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.workspace_premium_rounded,
                size: 72, color: AppColors.coin),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Unlock the full journey',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Python Peaks is free forever. Unlock Game Forge, Pixel '
              'Studio, Data Delta, and Mind Machine with a single one-time '
              'purchase — no subscriptions, no ads.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (_busy)
              const Center(child: CircularProgressIndicator())
            else
              PrimaryButton(label: 'Unlock PRO', onPressed: _buy),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: _busy ? null : _restore,
              child: const Text('Restore purchases'),
            ),
            if (_message != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(_message!, textAlign: TextAlign.center),
              ),
          ],
        ),
      ),
    );
  }
}
