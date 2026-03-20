import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:provider/provider.dart';

import 'config/dependencies.dart';
import 'famaapp.dart';

/// Launch with `flutter run --target lib/main.dart`.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  runApp(MultiProvider(providers: stagingProviders, child: const FamaApp()));
}
