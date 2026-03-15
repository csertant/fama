import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/managers/session/session_manager.dart';
import '../data/repositories/profile/profile_repository.dart';
import '../ui/home/home_screen.dart';
import '../ui/home/home_viewmodel.dart';
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
      routes: const [],
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
