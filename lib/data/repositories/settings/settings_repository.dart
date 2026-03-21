import 'package:flutter/material.dart';

import '../../../models/app_settings.dart';
import '../../../utils/result.dart';

abstract class SettingsRepository extends ChangeNotifier {
  AppSettings get appSettings;

  Future<Result<void>> load();

  Future<Result<AppSettings>> getAppSettings();

  Future<Result<void>> updateLanguage({required final String languageCode});

  Future<Result<void>> updateTheme({required final ThemeMode theme});
}
