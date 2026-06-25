import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';
import '../ui/theme/app_theme.dart';
import '../ui/tokens/app_text_styles.dart';
import 'app_constants.dart';
import 'router.dart';

class CodeVerseApp extends ConsumerWidget {
  const CodeVerseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dyslexiaFontEnabled =
        ref.watch(playerProfileProvider).dyslexiaFontEnabled;
    final fontFamilyOverride =
        dyslexiaFontEnabled ? AppFontFamilies.dyslexiaFriendly : null;

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(fontFamilyOverride: fontFamilyOverride),
      darkTheme: AppTheme.dark(fontFamilyOverride: fontFamilyOverride),
      routerConfig: appRouter,
    );
  }
}
