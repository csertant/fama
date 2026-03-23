import 'package:drift/drift.dart';

import '../../../utils/utils.dart';
import '../../database/database.dart';
import '../../services/local_data_service/local_data_service.dart';
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
    final parsedFeedResult = await _rssService.fetchFeed(url: url);
    switch (parsedFeedResult) {
      case Ok<ParsedFeed>():
        final parsedFeed = parsedFeedResult.value;
        final newSource = SourcesCompanion.insert(
          profileId: profileId,
          url: url,
          title: parsedFeed.title,
          description: Value(parsedFeed.description),
          siteUrl: Value(parsedFeed.siteUrl),
          iconUrl: Value(parsedFeed.imageUrl),
          lastSyncedAt: Value(DateTime.now()),
        );
        //TODO: If we get an id for the source, we should also sync the
        //articles for it immediately
        return _localDataService.saveSource(source: newSource);
      case Error<ParsedFeed>():
        return Result.error(parsedFeedResult.error);
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
