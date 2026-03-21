import '../../../utils/utils.dart';
import '../../database/database.dart';
import 'local_data_service.dart';

class LocalDataServiceProd implements LocalDataService {
  LocalDataServiceProd({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  // ---- Session management ----

  @override
  Future<Result<Session>> getSession() async {
    try {
      final result = await _database.getSession();
      if (result == null) {
        return Result.error(Exception('No session found'));
      }
      return Result.ok(result);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> saveSession({
    required final SessionsCompanion session,
  }) async {
    try {
      await _database.insertOrUpdateSession(session: session);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> removeSession() async {
    try {
      await _database.deleteSession();
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // ---- Profile management ----

  @override
  Future<Result<Profile>> getDefaultProfile() async {
    try {
      final result = await _database.getDefaultProfile();
      return Result.ok(result);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> saveProfile({
    required final ProfilesCompanion profile,
  }) async {
    try {
      await _database.insertOrUpdateProfile(profile: profile);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> removeProfile({required Id profileId}) async {
    try {
      await _database.deleteProfile(profileId: profileId);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Stream<List<Profile>> watchProfiles() {
    return _database.watchProfiles();
  }

  // ---- Source management ----

  @override
  Future<Result<void>> saveSource({required SourcesCompanion source}) async {
    try {
      await _database.insertOrUpdateSource(source: source);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> removeSource({required Id sourceId}) async {
    try {
      await _database.deleteSource(sourceId: sourceId);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Stream<List<Source>> watchSourcesForProfile({required final Id profileId}) {
    return _database.watchSourcesForProfile(profileId: profileId);
  }

  // ---- Article management ----

  @override
  Future<Result<void>> saveArticles({
    required List<ArticlesCompanion> articles,
  }) async {
    try {
      await _database.insertOrUpdateArticles(articles: articles);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> markArticleAsRead({required Id articleId}) async {
    try {
      await _database.updateArticleStatus(articleId: articleId, isRead: true);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> markArticleAsUnread({required Id articleId}) async {
    try {
      await _database.updateArticleStatus(articleId: articleId, isRead: false);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> markArticleAsSaved({required Id articleId}) async {
    try {
      await _database.updateArticleStatus(articleId: articleId, isSaved: true);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> markArticleAsUnsaved({required Id articleId}) async {
    try {
      await _database.updateArticleStatus(articleId: articleId, isSaved: false);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> removeOldReadArticles({required DateTime before}) async {
    try {
      await _database.deleteOldReadArticles(before: before);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Stream<List<Article>> watchUnreadArticles({required final Id profileId}) {
    return _database.watchUnreadArticles(profileId: profileId);
  }

  @override
  Stream<List<Article>> watchSavedArticles({required final Id profileId}) {
    return _database.watchSavedArticles(profileId: profileId);
  }

  @override
  Stream<List<Article>> watchArticles({required final Id profileId}) {
    return _database.watchArticles(profileId: profileId);
  }
}
