import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_constants.dart';
import '../../../ui/ui.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(AppConstants.appTagline),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Component Gallery (dev)',
              onPressed: () => context.push('/dev/components'),
            ),
          ],
        ),
      ),
    );
  }
}
