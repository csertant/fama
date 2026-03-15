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
}
