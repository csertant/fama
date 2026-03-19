import 'package:flutter/foundation.dart';

import '../../../utils/result.dart';
import '../../../utils/types.dart';
import '../../database/database.dart';
import '../../services/local_data_service.dart';
import 'session_manager.dart';

class SessionManagerProd extends ChangeNotifier implements SessionManager {
  SessionManagerProd({required final LocalDataService localDataService})
    : _localDataService = localDataService;

  final LocalDataService _localDataService;

  ProfileId? _profileId;

  @override
  ProfileId get profileId => _profileId!;
  @override
  bool get hasProfilePresent => _profileId != null;

  @override
  Future<Result<void>> initializeSession({
    required final Id id,
    required final ProfileId profileId,
  }) {
    _profileId = profileId;
    notifyListeners();
    return _localDataService.saveSession(Session(id: id, profileId: profileId));
  }

  @override
  Future<Result<void>> endSession() {
    _profileId = null;
    notifyListeners();
    return _localDataService.removeSession();
  }

  @override
  Future<Result<void>> loadSavedSession() async {
    final result = await _localDataService.getSession();
    switch (result) {
      case Ok<Session>():
        _profileId = result.value.profileId;
        notifyListeners();
      case Error<Session>():
        break;
    }
    return result;
  }
}
