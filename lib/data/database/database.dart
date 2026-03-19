import 'package:drift/drift.dart';

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
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();

        await into(profiles).insert(
          ProfilesCompanion.insert(
            name: 'Alapértelmezett',
            isDefault: const Value(true),
          ),
        );
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<List<Source>> getSourcesForProfile(int profileId) {
    return (select(sources)..where((s) => s.profileId.equals(profileId))).get();
  }

  Future<void> insertOrUpdateArticle(ArticlesCompanion article) {
    return into(articles).insert(article, mode: InsertMode.insertOrReplace);
  }
}
