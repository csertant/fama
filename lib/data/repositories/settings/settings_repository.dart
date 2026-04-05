import 'package:flutter/material.dart';

import '../../../utils/result.dart';
import '../../services/shared_preferences_service/app_settings.dart';

abstract class SettingsRepository extends ChangeNotifier {
  AppSettings get appSettings;

  Future<Result<void>> load();

  Future<Result<void>> updateLanguage({required final String languageCode});

  Future<Result<void>> updateTheme({required final ThemeMode theme});
}
