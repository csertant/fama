import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';

import 'config/dependencies.dart';
import 'ui/bootstrap/bootstrap.dart';

/// Launch with `flutter run --target lib/main.dart`.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  runApp(MultiProvider(providers: stagingProviders, child: const Bootstrap()));
}
