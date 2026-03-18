import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/managers/session/session_manager.dart';
import '../data/repositories/profile/profile_repository.dart';
import '../ui/home/home_screen.dart';
import '../ui/home/home_viewmodel.dart';
import '../ui/profile/profile_screen.dart';
import '../ui/profile/profile_viewmodel.dart';
import '../ui/settings/settings_screen.dart';
import '../ui/settings/settings_viewmodel.dart';
import '../ui/sources/sources_screen.dart';
import '../ui/sources/sources_viewmodel.dart';
import '../ui/subscribe/subscribe_screen.dart';
import '../ui/subscribe/subscribe_viewmodel.dart';
import 'routes.dart';

GoRouter router(final ProfileRepository profileRepository) => GoRouter(
  initialLocation: Routes.profileSwitch,
  debugLogDiagnostics: true,
  redirect: _redirect,
  refreshListenable: profileRepository,
  routes: [
    GoRoute(
      path: Routes.profileSwitch,
      builder: (final context, final state) {
        return const Scaffold(
          body: Center(child: Text('Profile switch screen')),
        );
      },
    ),
    GoRoute(
      path: Routes.home,
      builder: (final context, final state) {
        final viewModel = HomeViewModel(profileRepository: profileRepository);
        return HomeScreen(viewModel: viewModel);
      },
      routes: [
        GoRoute(
          path: Routes.profileRelative,
          builder: (final context, final state) {
            final viewModel = ProfileViewModel(
              profileRepository: profileRepository,
            );
            return ProfileScreen(viewModel: viewModel);
          },
        ),
        GoRoute(
          path: Routes.settingsRelative,
          builder: (final context, final state) {
            final viewModel = SettingsViewModel(
              settingsRepository: context.read(),
            );
            return SettingsScreen(viewModel: viewModel);
          },
        ),
        GoRoute(
          path: Routes.sourcesRelative,
          builder: (final context, final state) {
            final viewModel = SourcesViewModel(
              sourceRepository: context.read(),
            );
            return SourcesScreen(viewModel: viewModel);
          },
        ),
        GoRoute(
          path: Routes.subscribeRelative,
          builder: (final context, final state) {
            final viewModel = SubscribeViewModel(
              sourceRepository: context.read(),
            );
            return SubscribeScreen(viewModel: viewModel);
          },
        ),
      ],
    ),
  ],
);

// From https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/redirection.dart
Future<String?> _redirect(
  final BuildContext context,
  final GoRouterState state,
) async {
  final hasProfilePresent = context.read<SessionManager>().hasProfilePresent;
  final isChosingProfile = state.matchedLocation == Routes.profileSwitch;
  if (!hasProfilePresent) {
    return Routes.profileSwitch;
  }

  if (isChosingProfile) {
    return Routes.home;
  }

  return null;
}
