import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'data/repositories/settings/settings_repository.dart';
import 'l10n/generated/app_localizations.dart';
import 'routing/router.dart';
import 'ui/core/themes/themes.dart';

enum FamaAppType { main, bootstrap }

class FamaApp extends StatefulWidget {
  const FamaApp.main({super.key}) : type = FamaAppType.main, home = null;
  const FamaApp.bootstrap({super.key, required this.home})
    : type = FamaAppType.bootstrap;

  final FamaAppType type;
  final Widget? home;

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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final appSettings = context.watch<SettingsRepository>().appSettings;
    switch (widget.type) {
      case FamaAppType.bootstrap:
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale(appSettings.languageCode),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appSettings.theme,
          home: widget.home,
        );
      case FamaAppType.main:
        return MaterialApp.router(
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
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
}
