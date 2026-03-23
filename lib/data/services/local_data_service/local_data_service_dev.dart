import '../../../utils/utils.dart';
import '../../database/database.dart';
import 'local_data_service.dart';

final Profile defaultProfile = Profile(
  id: 1,
  name: 'Default Profile',
  isDefault: true,
  createdAt: DateTime.now().subtract(const Duration(days: 1)),
  updatedAt: DateTime.now(),
);
final Profile otherProfile = Profile(
  id: 2,
  name: 'Other Profile',
  isDefault: false,
  createdAt: DateTime.now().subtract(const Duration(days: 2)),
  updatedAt: DateTime.now(),
);
final Source exampleSource = Source(
  id: 1,
  profileId: defaultProfile.id,
  title: 'Telex',
  url: 'https://telex.hu/rss',
  description: 'Telex Legfrissebb hírek',
  siteUrl: 'https://telex.hu',
  createdAt: DateTime.now().subtract(const Duration(days: 1)),
  updatedAt: DateTime.now(),
);
final List<Article> exampleArticles = List.generate(
  6,
  (index) => Article(
    id: index + 1,
    guid: (index + 1).toString(),
    sourceId: exampleSource.id,
    profileId: defaultProfile.id,
    title: 'Example Article ${index + 1}',
    author: 'Author ${index + 1}',
    url: 'https://telex.hu/article${index + 1}',
    summary: 'Description for article ${index + 1}',
    publishedAt: DateTime.now().subtract(Duration(days: index)),
    isRead: index.isEven,
    isSaved: index % 3 == 0,
    createdAt: DateTime.now().subtract(Duration(days: index)),
    updatedAt: DateTime.now().subtract(Duration(days: index)),
  ),
);

class LocalDataServiceDev implements LocalDataService {
  @override
  Future<Result<Session>> getSession() async {
    return const Result.ok(Session(id: 1, profileId: 1));
  }

  @override
  Future<Result<void>> saveSession({
    required final SessionsCompanion session,
  }) async {
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> removeSession() async {
    return const Result.ok(null);
  }

  @override
  Future<Result<List<Profile>>> getProfiles() async {
    return Result.ok([defaultProfile, otherProfile]);
  }

  @override
  Future<Result<Profile>> getDefaultProfile() async {
    return Result.ok(defaultProfile);
  }

  @override
  Future<Result<void>> saveProfile({
    required final ProfilesCompanion profile,
  }) async {
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> removeProfile({required Id profileId}) async {
    return const Result.ok(null);
  }

  @override
  Stream<List<Profile>> watchProfiles() {
    return Stream.value([defaultProfile, otherProfile]);
  }

  @override
  Future<Result<List<Source>>> getSourcesForProfile({
    required final Id profileId,
  }) async {
    return Result.ok([exampleSource.copyWith(profileId: profileId)]);
  }

  @override
  Future<Result<void>> saveSource({required SourcesCompanion source}) async {
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> removeSource({
    required ProfileId profileId,
    required Id sourceId,
  }) async {
    return const Result.ok(null);
  }

  @override
  Stream<List<Source>> watchSourcesForProfile({required final Id profileId}) {
    return Stream.value([exampleSource.copyWith(profileId: profileId)]);
  }

  @override
  Future<Result<List<Article>>> getUnreadArticles({
    required final Id profileId,
  }) async {
    return Result.ok(
      exampleArticles
          .where((article) => !article.isRead && article.profileId == profileId)
          .toList(),
    );
  }

  @override
  Future<Result<List<Article>>> getSavedArticles({
    required final Id profileId,
  }) async {
    return Result.ok(
      exampleArticles
          .where((article) => article.isSaved && article.profileId == profileId)
          .toList(),
    );
  }

  @override
  Future<Result<List<Article>>> getArticles({
    required final Id profileId,
  }) async {
    return Result.ok(
      exampleArticles
          .where((article) => article.profileId == profileId)
          .toList(),
    );
  }

  @override
  Future<Result<void>> saveArticles({
    required List<ArticlesCompanion> articles,
  }) async {
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> markArticleAsRead({required Id articleId}) async {
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> markArticleAsUnread({required Id articleId}) async {
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> markArticleAsSaved({required Id articleId}) async {
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> markArticleAsUnsaved({required Id articleId}) async {
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> removeOldReadArticles({required DateTime before}) async {
    return const Result.ok(null);
  }

  @override
  Stream<List<Article>> watchUnreadArticles({required final Id profileId}) {
    return Stream.value(
      exampleArticles
          .where((article) => !article.isRead && article.profileId == profileId)
          .toList(),
    );
  }

  @override
  Stream<List<Article>> watchSavedArticles({required final Id profileId}) {
    return Stream.value(
      exampleArticles
          .where((article) => article.isSaved && article.profileId == profileId)
          .toList(),
    );
  }

  @override
  Stream<List<Article>> watchArticles({required final Id profileId}) {
    return Stream.value(
      exampleArticles
          .where((article) => article.profileId == profileId)
          .toList(),
    );
  }
}
