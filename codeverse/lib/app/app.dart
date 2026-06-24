import 'package:flutter/material.dart';

import '../ui/theme/app_theme.dart';
import 'app_constants.dart';
import 'router.dart';

class CodeVerseApp extends StatelessWidget {
  const CodeVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: appRouter,
    );
  }
}
