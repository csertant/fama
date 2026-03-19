import 'package:flutter/foundation.dart';
import '../../../utils/result.dart';
import '../../../utils/types.dart';

abstract class SessionManager extends ChangeNotifier {
  ProfileId get profileId;
  bool get hasProfilePresent;

  Future<Result<void>> initializeSession({
    required final Id id,
    required final ProfileId profileId,
  });

  Future<Result<void>> endSession();

  Future<Result<void>> loadSavedSession();
}
