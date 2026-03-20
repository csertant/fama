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

  Session? _session;

  @override
  ProfileId? get profileId => _session?.profileId;
  @override
  bool get hasProfilePresent => _session != null;

  @override
  Future<Result<void>> initializeSession({required final ProfileId profileId}) {
    final session = SessionsCompanion.insert(profileId: profileId);
    notifyListeners();
    return _localDataService.saveSession(session: session);
  }

  @override
  Future<Result<void>> endSession() {
    _session = null;
    notifyListeners();
    return _localDataService.removeSession();
  }

  @override
  Future<Result<void>> loadSavedSession() async {
    final result = await _localDataService.getSession();
    switch (result) {
      case Ok<Session>():
        _session = result.value;
        notifyListeners();
      case Error<Session>():
        break;
    }
    return result;
  }
}
