import '../../../utils/utils.dart';
import '../../database/database.dart';
import 'local_data_service.dart';

class LocalDataServiceDev implements LocalDataService {
  @override
  Future<Result<Session>> getSession() {
    // Implementation for development environment
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> saveSession({required final SessionsCompanion session}) {
    // Implementation for development environment
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> removeSession() {
    // Implementation for development environment
    throw UnimplementedError();
  }

  @override
  Future<Result<Profile>> getDefaultProfile() {
    // Implementation for development environment
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> saveProfile({required final ProfilesCompanion profile}) {
    // Implementation for development environment
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> removeProfile({required Id profileId}) {
    // Implementation for development environment
    throw UnimplementedError();
  }

  @override
  Stream<List<Profile>> watchProfiles() {
    // Implementation for development environment
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> saveSource({required SourcesCompanion source}) {
    // Implementation for development environment
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> removeSource({required Id sourceId}) {
    // Implementation for development environment
    throw UnimplementedError();
  }

  @override
  Stream<List<Source>> watchSourcesForProfile({required final Id profileId}) {
    // Implementation for development environment
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> saveArticles({
    required List<ArticlesCompanion> articles,
  }) {
    // Implementation for development environment
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> markArticleAsRead({required Id articleId}) {
    // Implementation for development environment
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> markArticleAsUnread({required Id articleId}) {
    // Implementation for development environment
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> markArticleAsSaved({required Id articleId}) {
    // Implementation for development environment
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> markArticleAsUnsaved({required Id articleId}) {
    // Implementation for development environment
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> removeOldReadArticles({required DateTime before}) {
    // Implementation for development environment
    throw UnimplementedError();
  }

  @override
  Stream<List<Article>> watchUnreadArticles({required final Id profileId}) {
    // Implementation for development environment
    throw UnimplementedError();
  }

  @override
  Stream<List<Article>> watchSavedArticles({required final Id profileId}) {
    // Implementation for development environment
    throw UnimplementedError();
  }

  @override
  Stream<List<Article>> watchArticles({required final Id profileId}) {
    // Implementation for development environment
    throw UnimplementedError();
  }
}
