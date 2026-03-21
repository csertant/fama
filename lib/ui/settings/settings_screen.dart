import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../l10n/utils.dart';
import '../core/widgets/widgets.dart';
import 'settings_viewmodel.dart';
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
                  SettingsRadioGroup<ThemeMode>(
                    title: localizations.settingsThemeTitle,
                    subtitle: localizations.settingsThemeSubtitle,
                    options: viewModel.availableThemes,
                    optionLabels: viewModel.availableThemes
                        .map((e) => mapThemeModeToString(context, e))
                        .toList(),
                    selectedOption: viewModel.theme,
                    onChanged: (theme) async {
                      if (theme != null) {
                        await viewModel.updateTheme.execute(theme);
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
                    onChanged: (languageCode) async {
                      if (languageCode != null) {
                        await viewModel.updateLanguage.execute(languageCode);
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
}
