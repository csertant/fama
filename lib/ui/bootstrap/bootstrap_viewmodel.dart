import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/database/database.dart';
import '../../data/managers/session/session_manager.dart';
import '../../data/repositories/profile/profile_repository.dart';
import '../../data/repositories/settings/settings_repository.dart';
import '../../utils/utils.dart';

class BootstrapViewModel extends ChangeNotifier {
  BootstrapViewModel({
    required this._settingsRepository,
    required this._profileRepository,
    required this._sessionManager,
  }) {
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
          return await _sessionManager.initializeSession(
            profileId: defaultProfile.id,
          );
        case Error<Profile>(error: final error):
          return Result.error(error);
      }
    } finally {
      notifyListeners();
    }
  }
}
