import '../../../models/app_settings.dart';
import '../../../utils/result.dart';

abstract class SettingsRepository {
  Future<Result<AppSettings>> getAppSettings();

  Future<Result<void>> updateLanguage({required final String languageCode});

  Future<Result<void>> updateTheme({required final AppTheme theme});
}
