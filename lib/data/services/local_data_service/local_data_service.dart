import '../../../utils/utils.dart';
import '../../database/database.dart';

abstract class LocalDataService {
  Future<Result<Session>> getSession();

  Future<Result<void>> saveSession({required final SessionsCompanion session});

  Future<Result<void>> removeSession();

  Future<Result<Profile>> getDefaultProfile();

  Future<Result<void>> saveProfile({required final ProfilesCompanion profile});

  Future<Result<void>> removeProfile({required Id profileId});

  Stream<List<Profile>> watchProfiles();

  Future<Result<void>> saveSource({required SourcesCompanion source});

  Future<Result<void>> removeSource({required Id sourceId});

  Stream<List<Source>> watchSourcesForProfile({required final Id profileId});

  Future<Result<void>> saveArticles({
    required List<ArticlesCompanion> articles,
  });

  Future<Result<void>> markArticleAsRead({required Id articleId});

  Future<Result<void>> markArticleAsUnread({required Id articleId});

  Future<Result<void>> markArticleAsSaved({required Id articleId});

  Future<Result<void>> markArticleAsUnsaved({required Id articleId});

  Future<Result<void>> removeOldReadArticles({required DateTime before});

  Stream<List<Article>> watchUnreadArticles({required final Id profileId});

  Stream<List<Article>> watchSavedArticles({required final Id profileId});

  Stream<List<Article>> watchArticles({required final Id profileId});
}
