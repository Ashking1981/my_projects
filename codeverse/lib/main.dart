import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'data/local/hive_setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpHive();
  runApp(const ProviderScope(child: CodeVerseApp()));
}
