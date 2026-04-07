import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/managers/session/session_manager.dart';
import '../data/repositories/article/article_repository.dart';
import '../data/repositories/profile/profile_repository.dart';
import '../data/repositories/settings/settings_repository.dart';
import '../data/repositories/source/source_repository.dart';
import '../data/services/connectivity_service/connectivity_service.dart';
import '../ui/core/widgets/custom_screen.dart';
import '../ui/explore/explore_screen.dart';
import '../ui/explore/explore_viewmodel.dart';
import '../ui/feed/feed_screen.dart';
import '../ui/feed/feed_viewmodel.dart';
import '../ui/saved/saved_screen.dart';
import '../ui/saved/saved_viewmodel.dart';
import '../ui/settings/settings_screen.dart';
import '../ui/settings/settings_viewmodel.dart';
import '../ui/sources/sources_screen.dart';
import '../ui/sources/sources_viewmodel.dart';
import 'routes.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.feed,
  debugLogDiagnostics: true,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return CustomScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.feed,
              builder: (context, state) {
                final viewModel = FeedViewModel(
                  sessionManager: context.read<SessionManager>(),
                  articleRepository: context.read<ArticleRepository>(),
                  connectivityService: context.read<ConnectivityService>(),
                );
                return FeedScreen(viewModel: viewModel);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.sources,
              builder: (context, state) {
                final viewModel = SourcesViewModel(
                  sessionManager: context.read<SessionManager>(),
                  sourceRepository: context.read<SourceRepository>(),
                );
                return SourcesScreen(viewModel: viewModel);
              },
              routes: [
                GoRoute(
                  path: Routes.exploreSegment,
                  builder: (context, state) {
                    final viewModel = ExploreViewModel(
                      sessionManager: context.read<SessionManager>(),
                      sourceRepository: context.read<SourceRepository>(),
                      connectivityService: context.read<ConnectivityService>(),
                    );
                    return ExploreScreen(viewModel: viewModel);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.saved,
              builder: (context, state) {
                final viewModel = SavedViewModel(
                  sessionManager: context.read<SessionManager>(),
                  articleRepository: context.read<ArticleRepository>(),
                );
                return SavedScreen(viewModel: viewModel);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.settings,
              builder: (context, state) {
                final viewModel = SettingsViewModel(
                  sessionManager: context.read<SessionManager>(),
                  profileRepository: context.read<ProfileRepository>(),
                  settingsRepository: context.read<SettingsRepository>(),
                );
                return SettingsScreen(viewModel: viewModel);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
