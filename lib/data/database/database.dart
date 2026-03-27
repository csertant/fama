import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../utils/types.dart';

part 'database.g.dart';

class Profiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();

  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get profileId => integer().references(Profiles, #id)();
}

class Sources extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get profileId => integer().references(Profiles, #id)();

  TextColumn get url => text().unique()();

  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get siteUrl => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get iconUrl => text().nullable()();

  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Articles extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get sourceId => integer().references(Sources, #id)();
  IntColumn get profileId => integer().references(Profiles, #id)();

  // RSS unique identifier
  TextColumn get guid => text()();

  TextColumn get url => text()();
  TextColumn get title => text()();
  TextColumn get content => text().nullable()();
  TextColumn get summary => text().nullable()();
  TextColumn get author => text().nullable()();
  TextColumn get imageUrl => text().nullable()();

  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  BoolColumn get isSaved => boolean().withDefault(const Constant(false))();

  DateTimeColumn get publishedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {sourceId, guid},
  ];
}

@DriftDatabase(tables: [Profiles, Sessions, Sources, Articles])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'fama_db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');

        // Ensure at least one profile exists.
        await customStatement(
          'INSERT INTO profiles (name, is_default, created_at, updated_at) '
          "SELECT 'Default Profile', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP "
          'WHERE NOT EXISTS (SELECT 1 FROM profiles)',
        );

        // Keep a single default profile (lowest id wins).
        await customStatement(
          'UPDATE profiles SET is_default = 0 '
          'WHERE id NOT IN '
          '(SELECT id FROM profiles WHERE is_default = 1 ORDER BY id LIMIT 1)',
        );
        await customStatement(
          'UPDATE profiles SET is_default = 1 '
          'WHERE id = (SELECT id FROM profiles ORDER BY id LIMIT 1) '
          'AND NOT EXISTS (SELECT 1 FROM profiles WHERE is_default = 1)',
        );

        // Keep session table singleton-safe.
        await customStatement(
          'DELETE FROM sessions '
          'WHERE id NOT IN (SELECT id FROM sessions ORDER BY id DESC LIMIT 1)',
        );
        await customStatement(
          'UPDATE sessions SET id = 1 '
          'WHERE id = (SELECT id FROM sessions ORDER BY id DESC LIMIT 1) '
          'AND id != 1',
        );
      },
    );
  }

  // ---- Methods ----
  // ---- Session management ----

  Future<Session?> getSession() {
    return select(sessions).getSingleOrNull();
  }

  Future<void> insertOrUpdateSession({required SessionsCompanion session}) {
    return into(sessions).insertOnConflictUpdate(session);
  }

  Future<void> deleteSession() {
    return delete(sessions).go();
  }

  // ---- Profile management ----

  Future<List<Profile>> getProfiles() {
    return select(profiles).get();
  }

  Future<Profile> getDefaultProfile() {
    return (select(
      profiles,
    )..where((p) => p.isDefault.equals(true))).getSingle();
  }

  Future<void> insertOrUpdateProfile({required ProfilesCompanion profile}) {
    return into(profiles).insertOnConflictUpdate(profile);
  }

  Future<void> deleteProfile({required Id profileId}) {
    return (delete(profiles)..where((p) => p.id.equals(profileId))).go();
  }

  Stream<List<Profile>> watchProfiles() {
    return select(profiles).watch();
  }

  // ---- Source management ----

  Future<List<Source>> getSourcesForProfile({required final Id profileId}) {
    return (select(sources)..where((s) => s.profileId.equals(profileId))).get();
  }

  Future<void> insertOrUpdateSource({required SourcesCompanion source}) {
    return into(sources).insertOnConflictUpdate(source);
  }

  Future<void> deleteSource({
    required ProfileId profileId,
    required Id sourceId,
  }) {
    return (delete(sources)
          ..where((s) => s.id.equals(sourceId) & s.profileId.equals(profileId)))
        .go();
  }

  Stream<List<Source>> watchSourcesForProfile({required final Id profileId}) {
    return (select(
      sources,
    )..where((s) => s.profileId.equals(profileId))).watch();
  }

  // ---- Article management ----

  Future<List<Article>> getUnreadArticles({required final Id profileId}) {
    final query =
        select(
            articles,
          ).join([innerJoin(sources, sources.id.equalsExp(articles.sourceId))])
          ..where(
            articles.isRead.equals(false) & sources.profileId.equals(profileId),
          )
          ..orderBy([OrderingTerm.desc(articles.publishedAt)]);
    return query.get().then((rows) {
      return rows.map((row) => row.readTable(articles)).toList();
    });
  }

  Future<List<Article>> getSavedArticles({required final Id profileId}) {
    final query =
        select(
            articles,
          ).join([innerJoin(sources, sources.id.equalsExp(articles.sourceId))])
          ..where(
            articles.isSaved.equals(true) & sources.profileId.equals(profileId),
          )
          ..orderBy([OrderingTerm.desc(articles.publishedAt)]);
    return query.get().then((rows) {
      return rows.map((row) => row.readTable(articles)).toList();
    });
  }

  Future<List<Article>> getArticles({required final Id profileId}) {
    final query =
        select(
            articles,
          ).join([innerJoin(sources, sources.id.equalsExp(articles.sourceId))])
          ..where(sources.profileId.equals(profileId))
          ..orderBy([OrderingTerm.desc(articles.publishedAt)]);
    return query.get().then((rows) {
      return rows.map((row) => row.readTable(articles)).toList();
    });
  }

  Future<void> insertOrUpdateArticles({
    required List<ArticlesCompanion> articles,
  }) {
    return batch((final batch) {
      batch.insertAllOnConflictUpdate(this.articles, articles);
    });
  }

  Future<void> updateArticleStatus({
    required Id articleId,
    bool? isRead,
    bool? isSaved,
  }) {
    return (update(articles)..where((a) => a.id.equals(articleId))).write(
      ArticlesCompanion(
        isRead: isRead != null ? Value(isRead) : const Value.absent(),
        isSaved: isSaved != null ? Value(isSaved) : const Value.absent(),
      ),
    );
  }

  Future<void> deleteOldReadArticles({required DateTime before}) {
    return (delete(articles)..where(
          (a) =>
              a.isRead.equals(true) &
              a.isSaved.equals(false) &
              a.publishedAt.isSmallerThanValue(before),
        ))
        .go();
  }

  Stream<List<Article>> watchUnreadArticles({required final Id profileId}) {
    final query =
        select(
            articles,
          ).join([innerJoin(sources, sources.id.equalsExp(articles.sourceId))])
          ..where(
            articles.isRead.equals(false) & sources.profileId.equals(profileId),
          )
          ..orderBy([OrderingTerm.desc(articles.publishedAt)]);
    return query.watch().map((rows) {
      return rows.map((row) => row.readTable(articles)).toList();
    });
  }

  Stream<List<Article>> watchSavedArticles({required final Id profileId}) {
    final query =
        select(
            articles,
          ).join([innerJoin(sources, sources.id.equalsExp(articles.sourceId))])
          ..where(
            articles.isSaved.equals(true) & sources.profileId.equals(profileId),
          )
          ..orderBy([OrderingTerm.desc(articles.publishedAt)]);
    return query.watch().map((rows) {
      return rows.map((row) => row.readTable(articles)).toList();
    });
  }

  Stream<List<Article>> watchArticles({required final Id profileId}) {
    final query =
        select(
            articles,
          ).join([innerJoin(sources, sources.id.equalsExp(articles.sourceId))])
          ..where(sources.profileId.equals(profileId))
          ..orderBy([OrderingTerm.desc(articles.publishedAt)]);
    return query.watch().map((rows) {
      return rows.map((row) => row.readTable(articles)).toList();
    });
  }
}
