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
    required this._localDataService,
    required this._remoteDataService,
    required this._rssService,
  });

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
  Future<Result<List<Source>>> getSourcesForProfile({required Id profileId}) {
    return _localDataService.getSourcesForProfile(profileId: profileId);
  }

  @override
  Stream<List<Source>> watchSourcesForProfile({required Id profileId}) {
    return _localDataService.watchSourcesForProfile(profileId: profileId);
  }

  @override
  Future<Result<void>> saveSource({
    required Id profileId,
    required String url,
  }) async {
    final parsedFeedResult = await _rssService.fetchFeed(url: url);
    if (parsedFeedResult is Ok<ParsedFeed>) {
      final parsedFeed = parsedFeedResult.value;
      final newSource = SourcesCompanion.insert(
        profileId: profileId,
        url: url,
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
  Future<Result<void>> removeSource({
    required Id profileId,
    required Id sourceId,
  }) {
    return _localDataService.removeSource(
      profileId: profileId,
      sourceId: sourceId,
    );
  }
}
