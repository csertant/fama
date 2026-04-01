import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/database/database.dart';
import '../data/managers/session/session_manager.dart';
import '../data/managers/session/session_manager_dev.dart';
import '../data/managers/session/session_manager_prod.dart';
import '../data/repositories/article/article_repository.dart';
import '../data/repositories/article/article_repository_local.dart';
import '../data/repositories/profile/profile_repository.dart';
import '../data/repositories/profile/profile_repository_local.dart';
import '../data/repositories/settings/settings_repository.dart';
import '../data/repositories/settings/settings_repository_local.dart';
import '../data/repositories/source/source_repository.dart';
import '../data/repositories/source/source_repository_local.dart';
import '../data/services/local_data_service/local_data_service.dart';
import '../data/services/local_data_service/local_data_service_dev.dart';
import '../data/services/local_data_service/local_data_service_prod.dart';
import '../data/services/remote_data_service/remote_data_service.dart';
import '../data/services/rss_service/rss_service.dart';
import '../data/services/shared_preferences_service/shared_preferences_service.dart';

List<SingleChildWidget> _sharedProviders = [
  Provider(create: (final context) => RemoteDataService()),
  Provider(create: (final context) => RssService()),
  Provider(create: (final context) => SharedPreferencesService()),
  Provider(
    create: (final context) =>
        ArticleRepositoryLocal(
              rssService: context.read<RssService>(),
              localDataService: context.read<LocalDataService>(),
            )
            as ArticleRepository,
  ),
  Provider(
    create: (final context) =>
        ProfileRepositoryLocal(
              localDataService: context.read<LocalDataService>(),
            )
            as ProfileRepository,
  ),
  Provider(
    create: (final context) =>
        SourceRepositoryLocal(
              localDataService: context.read<LocalDataService>(),
              remoteDataService: context.read<RemoteDataService>(),
              rssService: context.read<RssService>(),
            )
            as SourceRepository,
  ),
  ChangeNotifierProvider(
    create: (final context) =>
        SettingsRepositoryLocal(
              sharedPreferencesService: context
                  .read<SharedPreferencesService>(),
            )
            as SettingsRepository,
  ),
];

List<SingleChildWidget> get stagingProviders {
  return [
    Provider<AppDatabase>(
      create: (final context) => AppDatabase(),
      dispose: (final context, final database) => database.close(),
    ),
    Provider(
      create: (final context) =>
          LocalDataServiceProd(database: context.read<AppDatabase>())
              as LocalDataService,
    ),
    ..._sharedProviders,
    ChangeNotifierProvider(
      create: (final context) =>
          SessionManagerProd(localDataService: context.read<LocalDataService>())
              as SessionManager,
    ),
  ];
}

List<SingleChildWidget> get developmentProviders {
  return [
    Provider(
      create: (final context) => LocalDataServiceDev() as LocalDataService,
    ),
    ..._sharedProviders,
    ChangeNotifierProvider(
      create: (final context) => SessionManagerDev() as SessionManager,
    ),
  ];
}
