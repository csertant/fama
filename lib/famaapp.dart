import 'package:flutter/material.dart';

import 'l10n/generated/app_localizations.dart';
import 'routing/router.dart';
import 'ui/core/themes/themes.dart';

class FamaApp extends StatefulWidget {
  const FamaApp({super.key});

  static void setLocale(final BuildContext context, final Locale newLocale) {
    final state = context.findAncestorStateOfType<_FamaAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<FamaApp> createState() => _FamaAppState();
}

class _FamaAppState extends State<FamaApp> {
  Locale? _locale;

  void setLocale(final Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return MaterialApp.router(
      title: 'fáma',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router(),
    );
  }
}
