import 'dart:async';

import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../l10n/utils.dart';
import '../core/widgets/widgets.dart';
import 'settings_viewmodel.dart';
import 'widgets/settings_profiles_group.dart';
import 'widgets/settings_radio_group.dart';

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
            return ErrorIndicator(
              title: localizations.settingsLoadErrorTitle,
              label: localizations.settingsLoadErrorLabel,
              onPressed: viewModel.load.execute,
            );
          }
        },
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SettingsProfilesGroup(
                    title: localizations.settingsProfilesTitle,
                    subtitle: localizations.settingsProfilesSubtitle,
                    profiles: viewModel.profiles,
                    selectedProfile: viewModel.activeProfile,
                    onNewProfile: () => _showCreateCollectionDialog(context),
                    onModifyProfile: (profile) =>
                        unawaited(viewModel.modifyProfile.execute(profile)),
                    onRemoveProfile: (profile) =>
                        unawaited(viewModel.removeProfile.execute(profile)),
                    onSwitchProfile: (profile) => {
                      if (profile != null)
                        unawaited(viewModel.switchProfile.execute(profile)),
                    },
                  ),
                  SettingsRadioGroup<ThemeMode>(
                    title: localizations.settingsThemeTitle,
                    subtitle: localizations.settingsThemeSubtitle,
                    options: viewModel.availableThemes,
                    optionLabels: viewModel.availableThemes
                        .map((e) => mapThemeModeToString(context, e))
                        .toList(),
                    selectedOption: viewModel.theme,
                    onChanged: (theme) {
                      if (theme != null) {
                        unawaited(viewModel.updateTheme.execute(theme));
                      }
                    },
                  ),
                  SettingsRadioGroup<String>(
                    title: localizations.settingsLanguageTitle,
                    subtitle: localizations.settingsLanguageSubtitle,
                    options: viewModel.availableLocales
                        .map((e) => e.languageCode)
                        .toList(),
                    optionLabels: viewModel.availableLocales
                        .map(
                          (e) =>
                              mapLanguageCodeToString(context, e.languageCode),
                        )
                        .toList(),
                    selectedOption: viewModel.language,
                    onChanged: (languageCode) {
                      if (languageCode != null) {
                        unawaited(
                          viewModel.updateLanguage.execute(languageCode),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  //TODO: move to modalsheet
  Future<void> _showCreateCollectionDialog(BuildContext context) async {
    final textController = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create collection'),
          content: TextField(
            controller: textController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Collection name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(textController.text.trim());
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );

    if (name != null && name.trim().isNotEmpty) {
      unawaited(viewModel.createProfile.execute(name));
    }
  }
}
