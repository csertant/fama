import '../../utils/result.dart';
import '../database/database.dart';

class LocalDataService {
  Future<Result<Session>> getSession() async {
    return const Result.ok(Session(id: 1, profileId: 1));
  }

  Future<Result<void>> saveSession(final Session session) async {
    return const Result.ok(null);
  }

  Future<Result<void>> removeSession() async {
    return const Result.ok(null);
  }
}
