import 'package:flutter/foundation.dart';

import '../../../utils/result.dart';
import '../../../utils/types.dart';
import 'session_manager.dart';

/// Currently [SessionManagerDev] simulates that the test user (user_007)
/// has an active session and is always logged in.
class SessionManagerDev extends ChangeNotifier implements SessionManager {
  SessionManagerDev();

  ProfileId? _profileId = 7;

  @override
  ProfileId get profileId => _profileId!;
  @override
  bool get hasProfilePresent => true;

  @override
  Future<Result<void>> initializeSession({
    required final Id id,
    required final ProfileId profileId,
  }) async {
    _profileId = profileId;
    notifyListeners();
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> endSession() async {
    _profileId = null;
    notifyListeners();
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> loadSavedSession() async {
    _profileId = 7;
    notifyListeners();
    return const Result.ok(null);
  }
}
