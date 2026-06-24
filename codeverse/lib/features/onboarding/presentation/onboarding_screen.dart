import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_constants.dart';
import '../../../data/providers.dart';
import '../../../ui/ui.dart';

/// Shown once, before the player has chosen a nickname. No login, no email,
/// no personal data collected — just a display name kept entirely on-device.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final nickname = _controller.text.trim();
    if (nickname.isEmpty) return;
    ref.read(playerProfileProvider.notifier).setNickname(nickname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome to ${AppConstants.appName}',
                style: AppTextStyles.display(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                AppConstants.appTagline,
                style: AppTextStyles.body(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: _controller,
                textAlign: TextAlign.center,
                maxLength: 20,
                decoration: const InputDecoration(
                  hintText: 'What should we call you?',
                ),
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                label: 'Start my journey',
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
