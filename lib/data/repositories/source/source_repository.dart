import '../../../utils/utils.dart';
import '../../database/database.dart';
import '../../services/remote_data_service/models.dart';

abstract class SourceRepository {
  Future<Result<List<SourceRecommendation>>> getSourceRecommendations();

  Future<Result<List<Source>>> getSourcesForProfile({required Id profileId});

  Stream<List<Source>> watchSourcesForProfile({required Id profileId});

  Future<Result<void>> saveSource({required Id profileId, required String url});

  Future<Result<void>> removeSource({
    required Id profileId,
    required Id sourceId,
  });
}
