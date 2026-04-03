import 'package:drift/drift.dart';

import '../../../utils/utils.dart';
import '../../database/database.dart';
import '../../services/local_data_service/local_data_service.dart';
import '../../services/rss_service/models.dart';
import '../../services/rss_service/rss_service.dart';
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
  Future<Result<List<Article>>> getUnreadArticles({required Id profileId}) {
    return _localDataService.getUnreadArticles(profileId: profileId);
  }

  @override
  Future<Result<List<Article>>> getSavedArticles({required Id profileId}) {
    return _localDataService.getSavedArticles(profileId: profileId);
  }

  @override
  Future<Result<List<Article>>> getArticles({required Id profileId}) {
    return _localDataService.getArticles(profileId: profileId);
  }

  @override
  Stream<List<Article>> watchUnreadArticles({required Id profileId}) {
    return _localDataService.watchUnreadArticles(profileId: profileId);
  }

  @override
  Stream<List<Article>> watchSavedArticles({required Id profileId}) {
    return _localDataService.watchSavedArticles(profileId: profileId);
  }

  @override
  Stream<List<Article>> watchArticles({required Id profileId}) {
    return _localDataService.watchArticles(profileId: profileId);
  }

  @override
  Future<Result<void>> markAsRead({
    required final Id profileId,
    required final Id articleId,
  }) {
    return _localDataService.markArticleAsRead(articleId: articleId);
  }

  @override
  Future<Result<void>> markAsUnread({
    required final Id profileId,
    required final Id articleId,
  }) {
    return _localDataService.markArticleAsUnread(articleId: articleId);
  }

  @override
  Future<Result<void>> markAsSaved({
    required final Id profileId,
    required final Id articleId,
  }) {
    return _localDataService.markArticleAsSaved(articleId: articleId);
  }

  @override
  Future<Result<void>> markAsUnsaved({
    required final Id profileId,
    required final Id articleId,
  }) {
    return _localDataService.markArticleAsUnsaved(articleId: articleId);
  }

  @override
  Future<Result<void>> syncArticlesForProfile({required Id profileId}) async {
    try {
      final sourcesResult = await _localDataService.getSourcesForProfile(
        profileId: profileId,
      );
      switch (sourcesResult) {
        case Ok<List<Source>>():
          final sources = sourcesResult.value;
          final syncTasks = sources.map(
            (source) => _syncSingleSource(profileId: profileId, source: source),
          );
          await Future.wait(syncTasks);
          return const Result.ok(null);
        case Error<List<Source>>():
          return sourcesResult;
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _syncSingleSource({
    required ProfileId profileId,
    required Source source,
  }) async {
    try {
      final parsedFeedResult = await _rssService.fetchFeed(url: source.url);
      switch (parsedFeedResult) {
        case Ok<ParsedFeed>():
          final parsedFeed = parsedFeedResult.value;
          final newArticles = parsedFeed.articles.map((parsedArticle) {
            return ArticlesCompanion.insert(
              profileId: profileId,
              sourceId: source.id,
              sourceName: source.name,
              guid: parsedArticle.guid,
              url: parsedArticle.url,
              title: parsedArticle.title,
              content: Value(parsedArticle.content),
              summary: Value(parsedArticle.summary),
              author: Value(parsedArticle.author),
              imageUrl: Value(parsedArticle.imageUrl),
              publishedAt: parsedArticle.publishedAt,
              updatedAt: Value(DateTime.now()),
            );
          }).toList();
          return _localDataService.saveArticles(articles: newArticles);
        case Error<ParsedFeed>():
          return Result.error(parsedFeedResult.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
