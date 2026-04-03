import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../../data/database/database.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../l10n/utils.dart';
import '../core/themes/dimensions.dart';
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
                    onNewProfile: () => _showCreateProfileModal(context),
                    onModifyProfile: (profile) =>
                        _showModifyProfileModal(context, profile),
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

  Future<void> _showCreateProfileModal(BuildContext context) async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.borderRadiusMedium),
        ),
      ),
      builder: (context) {
        return AnimatedBuilder(
          animation: viewModel.createProfile,
          builder: (context, _) {
            return CustomModalSheet(
              title: localizations.settingsCreateProfileTitle,
              actionLabel: localizations.settingsCreateProfileLabel,
              onAction: () async {
                if (nameController.text.isNotEmpty) {
                  await viewModel.createProfile.execute(
                    nameController.text,
                    descriptionController.text,
                  );
                  if (viewModel.createProfile.completed && context.mounted) {
                    viewModel.createProfile.clearResult();
                    Navigator.of(context).pop();
                  }
                }
              },
              isLoading: viewModel.createProfile.running,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: localizations.settingsCreateProfileSubtitle,
                    hintStyle: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: localizations.settingsCreateProfileDescription,
                    hintStyle: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showModifyProfileModal(
    BuildContext context,
    Profile profile,
  ) async {
    final nameController = TextEditingController.fromValue(
      TextEditingValue(text: profile.name),
    );
    final descriptionController = TextEditingController.fromValue(
      TextEditingValue(text: profile.description ?? ''),
    );
    final isDefaultController = ValueNotifier<bool>(profile.isDefault);
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.borderRadiusMedium),
        ),
      ),
      builder: (context) {
        return AnimatedBuilder(
          animation: viewModel.modifyProfile,
          builder: (context, _) {
            return CustomModalSheet(
              title: localizations.settingsModifyProfileTitle,
              actionLabel: localizations.settingsModifyProfileLabel,
              onAction: () async {
                if (nameController.text.isNotEmpty) {
                  await viewModel.modifyProfile.execute(
                    profile.copyWith(
                      name: nameController.text,
                      description: Value(
                        descriptionController.text.isNotEmpty
                            ? descriptionController.text
                            : null,
                      ),
                      isDefault: isDefaultController.value,
                    ),
                  );
                  if (viewModel.modifyProfile.completed && context.mounted) {
                    viewModel.modifyProfile.clearResult();
                    Navigator.of(context).pop();
                  }
                }
              },
              isLoading: viewModel.modifyProfile.running,
              children: [
                TextField(controller: nameController),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: localizations.settingsCreateProfileDescription,
                    hintStyle: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: isDefaultController,
                  builder: (context, isDefault, _) {
                    return CustomSwitch(
                      label: localizations.settingsModifyProfileIsDefaultLabel,
                      value: isDefault,
                      onChanged: (value) => isDefaultController.value = value,
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
