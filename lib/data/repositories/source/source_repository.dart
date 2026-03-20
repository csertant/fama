import '../../../utils/result.dart';
import '../../../utils/types.dart';
import '../../database/database.dart';

abstract class SourceRepository {
  Future<Result<void>> saveSource({
    required final Id profileId,
    required final String url,
  });

  Future<Result<void>> removeSource({
    required final Id profileId,
    required final Id sourceId,
  });

  Stream<List<Source>> watchSourcesForProfile({required final Id profileId});
}
