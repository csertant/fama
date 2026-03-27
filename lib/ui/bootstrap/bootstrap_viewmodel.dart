import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/database/database.dart';
import '../../data/managers/session/session_manager.dart';
import '../../data/repositories/profile/profile_repository.dart';
import '../../data/repositories/settings/settings_repository.dart';
import '../../utils/utils.dart';

class BootstrapViewModel extends ChangeNotifier {
  BootstrapViewModel({
    required SettingsRepository settingsRepository,
    required ProfileRepository profileRepository,
    required SessionManager sessionManager,
  }) : _settingsRepository = settingsRepository,
       _profileRepository = profileRepository,
       _sessionManager = sessionManager {
    load = Command0(_load);
    unawaited(load.execute());
  }

  final SettingsRepository _settingsRepository;
  final ProfileRepository _profileRepository;
  final SessionManager _sessionManager;

  late Command0<void> load;

  Future<Result<void>> _load() async {
    try {
      final settingsResult = await _settingsRepository.load();
      switch (settingsResult) {
        case Ok<void>():
          break;
        case Error<void>():
          return settingsResult;
      }

      final defaultProfileResult = await _profileRepository.getDefaultProfile();
      switch (defaultProfileResult) {
        case Ok<Profile>():
          final defaultProfile = defaultProfileResult.value;

          final savedSessionResult = await _sessionManager.loadSavedSession();
          switch (savedSessionResult) {
            case Ok<void>():
              if (_sessionManager.hasProfilePresent) {
                return const Result.ok(null);
              }
            case Error<void>():
              break;
          }

          return _sessionManager.initializeSession(
            profileId: defaultProfile.id,
          );
        case Error<Profile>():
          return Result.error(defaultProfileResult.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }
}
