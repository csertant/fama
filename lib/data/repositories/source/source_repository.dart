import '../../../utils/utils.dart';
import '../../database/database.dart';

abstract class SourceRepository {
  Future<Result<List<Source>>> getSourcesForProfile({
    required final Id profileId,
  });

  Stream<List<Source>> watchSourcesForProfile({required final Id profileId});

  Future<Result<void>> saveSource({
    required final Id profileId,
    required final String url,
  });

  Future<Result<void>> modifySource({
    required final Id profileId,
    required final Source source,
  });

  Future<Result<void>> removeSource({
    required final Id profileId,
    required final Id sourceId,
  });
}
