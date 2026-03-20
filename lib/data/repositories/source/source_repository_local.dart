import '../../../utils/utils.dart';
import '../../database/database.dart';
import '../../services/local_data_service.dart';
import '../../services/rss_service.dart';
import 'source_repository.dart';

class SourceRepositoryLocal implements SourceRepository {
  SourceRepositoryLocal({
    required final RssService rssService,
    required final LocalDataService localDataService,
  }) : _rssService = rssService,
       _localDataService = localDataService;

  final LocalDataService _localDataService;
  final RssService _rssService;

  @override
  Future<Result<void>> saveSource({
    required final Id profileId,
    required final String url,
  }) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> removeSource({
    required final Id profileId,
    required final Id sourceId,
  }) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Stream<List<Source>> watchSourcesForProfile({required final Id profileId}) {
    return _localDataService.watchSourcesForProfile(profileId: profileId);
  }
}
