import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'config/dependencies.dart';
import 'ui/bootstrap/bootstrap.dart';

/// Launch with `flutter run --target lib/main_dev.dart`.
void main() {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  unawaited(SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge));
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  usePathUrlStrategy();
  runApp(
    MultiProvider(providers: developmentProviders, child: const Bootstrap()),
  );
}
