import 'package:flutter/material.dart';

import 'app_constants.dart';
import 'router.dart';

class CodeVerseApp extends StatelessWidget {
  const CodeVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
