import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/managers/session/session_manager.dart';
import '../../data/repositories/profile/profile_repository.dart';
import '../../data/repositories/settings/settings_repository.dart';
import '../../famaapp.dart';
import '../../l10n/generated/app_localizations.dart';
import '../core/widgets/custom_error_indicator.dart';
import 'bootstrap_viewmodel.dart';

class Bootstrap extends StatefulWidget {
  const Bootstrap({super.key});

  @override
  State<Bootstrap> createState() => _BootstrapState();
}

class _BootstrapState extends State<Bootstrap> {
  late final BootstrapViewModel _bootstrapViewModel;

  @override
  void initState() {
    super.initState();
    _bootstrapViewModel = BootstrapViewModel(
      settingsRepository: context.read<SettingsRepository>(),
      profileRepository: context.read<ProfileRepository>(),
      sessionManager: context.read<SessionManager>(),
    );
  }

  @override
  void dispose() {
    _bootstrapViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _bootstrapViewModel.load,
      builder: (context, child) {
        if (_bootstrapViewModel.load.running ||
            !_bootstrapViewModel.load.completed) {
          return FamaApp.bootstrap(
            home: Builder(
              builder: (context) {
                final localizations = AppLocalizations.of(context)!;
                if (_bootstrapViewModel.load.running) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                return ErrorIndicator(
                  title: localizations.bootstrapLoadErrorTitle,
                  label: localizations.bootstrapLoadErrorLabel,
                  onPressed: _bootstrapViewModel.load.execute,
                );
              },
            ),
          );
        }
        return const FamaApp.main();
      },
    );
  }
}
