import 'package:drift/drift.dart';

import '../../../utils/utils.dart';
import '../../database/database.dart';
import '../../services/local_data_service/local_data_service.dart';
import '../../services/remote_data_service/models.dart';
import '../../services/remote_data_service/remote_data_service.dart';
import '../../services/rss_service/models.dart';
import '../../services/rss_service/rss_service.dart';
import 'source_repository.dart';

class SourceRepositoryLocal implements SourceRepository {
  SourceRepositoryLocal({
    required final LocalDataService localDataService,
    required final RemoteDataService remoteDataService,
    required final RssService rssService,
  }) : _localDataService = localDataService,
       _remoteDataService = remoteDataService,
       _rssService = rssService;

  final LocalDataService _localDataService;
  final RemoteDataService _remoteDataService;
  final RssService _rssService;

  static const String recommendationsCacheKey = 'source_recommendations';
  final Map<String, List<SourceRecommendation>> _recommendationsCache = {};

  @override
  Future<Result<List<SourceRecommendation>>> getSourceRecommendations() async {
    if (_recommendationsCache.containsKey(recommendationsCacheKey)) {
      return Result.ok(_recommendationsCache[recommendationsCacheKey]!);
    }
    final parsedRecommendationsResult = await _remoteDataService
        .fetchSourceRecommendations();
    if (parsedRecommendationsResult is Ok<List<SourceRecommendation>>) {
      final recommendations = parsedRecommendationsResult.value;
      _recommendationsCache[recommendationsCacheKey] = recommendations;
    }
    return parsedRecommendationsResult;
  }

  @override
  Future<Result<List<Source>>> getSourcesForProfile({
    required final Id profileId,
  }) {
    return _localDataService.getSourcesForProfile(profileId: profileId);
  }

  @override
  Stream<List<Source>> watchSourcesForProfile({required final Id profileId}) {
    return _localDataService.watchSourcesForProfile(profileId: profileId);
  }

  @override
  Future<Result<void>> saveSource({
    required final Id profileId,
    required final String url,
  }) async {
    final normalizedUrl = normalizeUrl(url);
    final parsedFeedResult = await _rssService.fetchFeed(url: normalizedUrl);
    if (parsedFeedResult is Ok<ParsedFeed>) {
      final parsedFeed = parsedFeedResult.value;
      final newSource = SourcesCompanion.insert(
        profileId: profileId,
        url: normalizedUrl,
        name: parsedFeed.title,
        description: Value(parsedFeed.description),
        siteUrl: Value(parsedFeed.siteUrl),
        iconUrl: Value(parsedFeed.imageUrl),
        lastSyncedAt: Value(DateTime.now()),
      );
      return _localDataService.saveSource(source: newSource);
    } else {
      return parsedFeedResult;
    }
  }

  @override
  Future<Result<void>> modifySource({
    required final Id profileId,
    required final Source source,
  }) {
    return _localDataService.saveSource(source: source.toCompanion(true));
  }

  @override
  Future<Result<void>> removeSource({
    required final Id profileId,
    required final Id sourceId,
  }) {
    return _localDataService.removeSource(
      profileId: profileId,
      sourceId: sourceId,
    );
  }
}
