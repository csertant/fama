import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../../utils/utils.dart';
import '../../database/database.dart';
import '../../services/local_data_service/local_data_service.dart';
import 'session_manager.dart';

class SessionManagerProd extends ChangeNotifier implements SessionManager {
  SessionManagerProd({required final LocalDataService localDataService})
    : _localDataService = localDataService;

  final LocalDataService _localDataService;

  Session? _session;

  @override
  ProfileId? get profileId => _session?.profileId;
  @override
  bool get hasSessionPresent => _session != null;

  @override
  Future<Result<void>> loadSavedSession() async {
    final result = await _localDataService.getSession();
    if (result is Ok<Session>) {
      _session = result.value;
      notifyListeners();
    }
    return switch (result) {
      Ok<Session>() => const Result.ok(null),
      Error<Session>() => Result.error(result.error),
    };
  }

  @override
  Future<Result<void>> initializeSession({
    required final ProfileId profileId,
  }) async {
    final session = SessionsCompanion.insert(
      id: const Value(1),
      profileId: profileId,
    );
    final result = await _localDataService.saveSession(session: session);
    if (result is Ok<void>) {
      _session = Session(id: 1, profileId: profileId);
      notifyListeners();
    }
    return result;
  }

  @override
  Future<Result<void>> endSession() {
    final removeResult = _localDataService.removeSession();
    if (removeResult is Ok<void>) {
      _session = null;
      notifyListeners();
    }
    return removeResult;
  }
}
