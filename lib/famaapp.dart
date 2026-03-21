import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'data/repositories/settings/settings_repository.dart';
import 'l10n/generated/app_localizations.dart';
import 'routing/router.dart';
import 'ui/core/themes/themes.dart';

class FamaApp extends StatefulWidget {
  const FamaApp({super.key});

  @override
  State<FamaApp> createState() => _FamaAppState();
}

class _FamaAppState extends State<FamaApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = router();
  }

  @override
  Widget build(final BuildContext context) {
    final appSettings = context.watch<SettingsRepository>().appSettings;

    return MaterialApp.router(
      title: 'fáma',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(appSettings.languageCode),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appSettings.theme,
      routerConfig: _router,
    );
  }
}
