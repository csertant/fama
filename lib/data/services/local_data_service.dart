import '../../models/session.dart';
import '../../utils/result.dart';

class LocalDataService {
  Future<Result<Session>> getSession() async {
    return Result.ok(Session(profileId: 'test'));
  }

  Future<Result<void>> saveSession(final Session session) async {
    return const Result.ok(null);
  }

  Future<Result<void>> removeSession() async {
    return const Result.ok(null);
  }
}
