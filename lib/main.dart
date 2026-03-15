import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:provider/provider.dart';

import 'config/dependencies.dart';
import 'famaapp.dart';

/// Launch with `flutter run --target lib/main.dart`.
void main() {
  usePathUrlStrategy();
  runApp(MultiProvider(providers: productionProviders, child: const FamaApp()));
}
