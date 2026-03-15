import '../../../models/app_settings.dart';
import '../../../utils/result.dart';

abstract class SettingsRepository {
  Future<Result<AppSettings>> getAppSettings();

  Future<Result<void>> updateLanguage(final String languageCode);

  Future<Result<void>> updateTheme(final AppTheme theme);
}
