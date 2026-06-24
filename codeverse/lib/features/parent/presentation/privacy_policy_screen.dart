import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../../app/app_constants.dart';
import '../../../ui/ui.dart';

/// Renders the bundled privacy policy markdown as plain text. Loaded from
/// [AppConstants.privacyPolicyAssetPath] rather than hardcoded here so the
/// policy text can be edited without touching Dart code.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: FutureBuilder<String>(
        future: rootBundle.loadString(AppConstants.privacyPolicyAssetPath),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(snapshot.data!),
          );
        },
      ),
    );
  }
}
