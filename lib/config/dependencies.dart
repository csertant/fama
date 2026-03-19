import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/managers/session/session_manager.dart';
import '../data/managers/session/session_manager_dev.dart';
import '../data/managers/session/session_manager_prod.dart';
import '../data/repositories/article/article_repository.dart';
import '../data/repositories/article/article_repository_local.dart';
import '../data/repositories/settings/settings_repository.dart';
import '../data/repositories/settings/settings_repository_local.dart';
import '../data/repositories/source/source_repository.dart';
import '../data/repositories/source/source_repository_local.dart';
import '../data/services/local_data_service.dart';
import '../data/services/rss_service.dart';
import '../data/services/shared_preferences_service.dart';

List<SingleChildWidget> _sharedProviders = [
  Provider(create: (final context) => RssService()),
  Provider(create: (final context) => LocalDataService()),
  Provider(create: (final context) => SharedPreferencesService()),
  Provider(
    create: (final context) =>
        SettingsRepositoryLocal(
              sharedPreferencesService: context
                  .read<SharedPreferencesService>(),
            )
            as SettingsRepository,
  ),
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
        SourceRepositoryLocal(
              rssService: context.read<RssService>(),
              localDataService: context.read<LocalDataService>(),
            )
            as SourceRepository,
  ),
];

List<SingleChildWidget> get stagingProviders {
  return [
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
    ..._sharedProviders,
    ChangeNotifierProvider(
      create: (final context) => SessionManagerDev() as SessionManager,
    ),
  ];
}
