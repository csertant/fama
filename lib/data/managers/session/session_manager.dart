import 'package:flutter/foundation.dart';
import '../../../utils/utils.dart';

abstract class SessionManager extends ChangeNotifier {
  ProfileId? get profileId;
  bool get hasSessionPresent;

  Future<Result<void>> loadSavedSession();

  Future<Result<void>> initializeSession({required final ProfileId profileId});

  Future<Result<void>> endSession();
}
