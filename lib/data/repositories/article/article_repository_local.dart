import '../../../utils/utils.dart';
import '../../database/database.dart';
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

  @override
  Future<Result<void>> syncArticlesForProfile({required Id profileId}) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> markAsRead({
    required final Id profileId,
    required final Id articleId,
  }) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> markAsUnread({
    required final Id profileId,
    required final Id articleId,
  }) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> markAsSaved({
    required final Id profileId,
    required final Id articleId,
  }) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> markAsUnsaved({
    required final Id profileId,
    required final Id articleId,
  }) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Stream<List<Article>> watchArticles({required Id profileId}) {
    return _localDataService.watchArticles(profileId: profileId);
  }

  @override
  Stream<List<Article>> watchUnreadArticles({required Id profileId}) {
    return _localDataService.watchUnreadArticles(profileId: profileId);
  }
}
