import '../../../utils/utils.dart';
import '../../database/database.dart';
import 'local_data_service.dart';

class LocalDataServiceProd implements LocalDataService {
  LocalDataServiceProd({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  // ---- Session management ----

  @override
  Future<Result<Session>> getSession() {
    return guardNotNull(
      _database.getSession,
      notFoundException: LocalDataNotFoundException('No session found'),
    );
  }

  @override
  Future<Result<void>> saveSession({required final SessionsCompanion session}) {
    return guardVoid(() => _database.insertOrUpdateSession(session: session));
  }

  @override
  Future<Result<void>> removeSession() {
    return guardVoid(_database.deleteSession);
  }

  // ---- Profile management ----

  @override
  Future<Result<List<Profile>>> getProfiles() {
    return guard(_database.getProfiles);
  }

  @override
  Future<Result<Profile>> getDefaultProfile() {
    return guard(_database.getDefaultProfile);
  }

  @override
  Future<Result<void>> saveProfile({required final ProfilesCompanion profile}) {
    return guardVoid(() => _database.insertOrUpdateProfile(profile: profile));
  }

  @override
  Future<Result<void>> removeProfile({required Id profileId}) {
    return guardVoid(() => _database.deleteProfile(profileId: profileId));
  }

  @override
  Stream<List<Profile>> watchProfiles() {
    return _database.watchProfiles();
  }

  // ---- Source management ----

  @override
  Future<Result<List<Source>>> getSourcesForProfile({
    required final Id profileId,
  }) {
    return guard(() => _database.getSourcesForProfile(profileId: profileId));
  }

  @override
  Future<Result<void>> saveSource({required SourcesCompanion source}) {
    return guardVoid(() => _database.insertOrUpdateSource(source: source));
  }

  @override
  Future<Result<void>> removeSource({
    required ProfileId profileId,
    required Id sourceId,
  }) {
    return guardVoid(
      () => _database.deleteSource(profileId: profileId, sourceId: sourceId),
    );
  }

  @override
  Stream<List<Source>> watchSourcesForProfile({required final Id profileId}) {
    return _database.watchSourcesForProfile(profileId: profileId);
  }

  // ---- Article management ----

  @override
  Future<Result<List<Article>>> getUnreadArticles({
    required final Id profileId,
  }) {
    return guard(() => _database.getUnreadArticles(profileId: profileId));
  }

  @override
  Future<Result<List<Article>>> getSavedArticles({
    required final Id profileId,
  }) {
    return guard(() => _database.getSavedArticles(profileId: profileId));
  }

  @override
  Future<Result<List<Article>>> getArticles({required final Id profileId}) {
    return guard(() => _database.getArticles(profileId: profileId));
  }

  @override
  Future<Result<void>> saveArticles({
    required List<ArticlesCompanion> articles,
  }) {
    return guardVoid(
      () => _database.insertOrUpdateArticles(articles: articles),
    );
  }

  @override
  Future<Result<void>> markArticleAsRead({required Id articleId}) {
    return guardVoid(
      () => _database.updateArticleStatus(articleId: articleId, isRead: true),
    );
  }

  @override
  Future<Result<void>> markArticleAsUnread({required Id articleId}) {
    return guardVoid(
      () => _database.updateArticleStatus(articleId: articleId, isRead: false),
    );
  }

  @override
  Future<Result<void>> markArticleAsSaved({required Id articleId}) {
    return guardVoid(
      () => _database.updateArticleStatus(articleId: articleId, isSaved: true),
    );
  }

  @override
  Future<Result<void>> markArticleAsUnsaved({required Id articleId}) {
    return guardVoid(
      () => _database.updateArticleStatus(articleId: articleId, isSaved: false),
    );
  }

  @override
  Future<Result<void>> removeOldReadArticles({required DateTime before}) {
    return guardVoid(() => _database.deleteOldReadArticles(before: before));
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
