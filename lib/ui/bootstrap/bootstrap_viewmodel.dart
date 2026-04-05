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
      if (settingsResult is Error<void>) {
        return settingsResult;
      }
      final defaultProfileResult = await _profileRepository.getDefaultProfile();
      switch (defaultProfileResult) {
        case Ok<Profile>(value: final defaultProfile):
          final savedSessionResult = await _sessionManager.loadSavedSession();
          if (savedSessionResult is Ok<void>) {
            if (_sessionManager.hasSessionPresent) {
              return const Result.ok(null);
            }
          }
          return _sessionManager.initializeSession(
            profileId: defaultProfile.id,
          );
        case Error<Profile>(error: final error):
          return Result.error(error);
      }
    } on Exception catch (e) {
      return Result.error(AppException.fromError(e));
    } finally {
      notifyListeners();
    }
  }
}
