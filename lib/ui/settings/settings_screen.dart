import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../core/widgets/widgets.dart';
import 'settings_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.viewModel});

  final SettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(title: localizations.settingsTitle),
      body: ListenableBuilder(
        listenable: viewModel.load,
        builder: (context, child) {
          if (viewModel.load.completed) {
            return child!;
          } else if (viewModel.load.running) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('Error loading settings'));
          }
        },
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            return const Center(child: Text('Settings loaded'));
          },
        ),
      ),
    );
  }
}
