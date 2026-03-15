import '../../services/local_data_service.dart';
import '../../services/rss_service.dart';
import 'article_repository.dart';

class ArticleRepositoryLocal implements ArticleRepository {
  ArticleRepositoryLocal({
    required final RssService rssService,
    required final LocalDataService localDataService,
  }) : _rssService = rssService,
       _localDataService = localDataService;

  final LocalDataService _localDataService;
  final RssService _rssService;
}
