import '../../utils/utils.dart';
import '../database/database.dart';

class LocalDataService {
  LocalDataService({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  // ---- Session management ----

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

  Future<Result<void>> removeSession() async {
    try {
      await _database.deleteSession();
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // ---- Profile management ----

  Future<Result<Profile>> getDefaultProfile() async {
    try {
      final result = await _database.getDefaultProfile();
      return Result.ok(result);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

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

  Future<Result<void>> removeProfile({required Id profileId}) async {
    try {
      await _database.deleteProfile(profileId: profileId);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Stream<List<Profile>> watchProfiles() {
    return _database.watchProfiles();
  }

  // ---- Source management ----

  Future<Result<void>> saveSource({required SourcesCompanion source}) async {
    try {
      await _database.insertOrUpdateSource(source: source);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> removeSource({required Id sourceId}) async {
    try {
      await _database.deleteSource(sourceId: sourceId);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Stream<List<Source>> watchSourcesForProfile({required final Id profileId}) {
    return _database.watchSourcesForProfile(profileId: profileId);
  }

  // ---- Article management ----

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

  Future<Result<void>> markArticleAsRead({required Id articleId}) async {
    try {
      await _database.updateArticleStatus(articleId: articleId, isRead: true);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> markArticleAsUnread({required Id articleId}) async {
    try {
      await _database.updateArticleStatus(articleId: articleId, isRead: false);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> markArticleAsSaved({required Id articleId}) async {
    try {
      await _database.updateArticleStatus(articleId: articleId, isSaved: true);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> markArticleAsUnsaved({required Id articleId}) async {
    try {
      await _database.updateArticleStatus(articleId: articleId, isSaved: false);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> removeOldReadArticles(DateTime before) async {
    try {
      await _database.deleteOldReadArticles(before);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Stream<List<Article>> watchUnreadArticles({required final Id profileId}) {
    return _database.watchUnreadArticles(profileId: profileId);
  }

  Stream<List<Article>> watchSavedArticles({required final Id profileId}) {
    return _database.watchSavedArticles(profileId: profileId);
  }

  Stream<List<Article>> watchArticles({required final Id profileId}) {
    return _database.watchArticles(profileId: profileId);
  }
}
