import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../../data/database/database.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../l10n/utils.dart';
import '../core/widgets/widgets.dart';
import 'settings_viewmodel.dart';
import 'widgets/settings_contacts.dart';
import 'widgets/settings_profiles_group.dart';
import 'widgets/settings_radio_group.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.viewModel});

  final SettingsViewModel viewModel;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.createProfile.addListener(_onCreateProfileResult);
    widget.viewModel.modifyProfile.addListener(_onModifyProfileResult);
    widget.viewModel.removeProfile.addListener(_onRemoveProfileResult);
  }

  @override
  void didUpdateWidget(covariant SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.createProfile.removeListener(_onCreateProfileResult);
    widget.viewModel.createProfile.addListener(_onCreateProfileResult);
    oldWidget.viewModel.modifyProfile.removeListener(_onModifyProfileResult);
    widget.viewModel.modifyProfile.addListener(_onModifyProfileResult);
    oldWidget.viewModel.removeProfile.removeListener(_onRemoveProfileResult);
    widget.viewModel.removeProfile.addListener(_onRemoveProfileResult);
  }

  @override
  void dispose() {
    widget.viewModel.createProfile.removeListener(_onCreateProfileResult);
    widget.viewModel.modifyProfile.removeListener(_onModifyProfileResult);
    widget.viewModel.removeProfile.removeListener(_onRemoveProfileResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(title: localizations.settingsTitle),
      body: ListenableBuilder(
        listenable: widget.viewModel.load,
        builder: (context, child) {
          if (widget.viewModel.load.completed) {
            return child!;
          } else if (widget.viewModel.load.running) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ErrorIndicator(
              title: localizations.settingsLoadErrorTitle,
              label: localizations.settingsLoadErrorLabel,
              onPressed: widget.viewModel.load.execute,
            );
          }
        },
        child: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SettingsProfilesGroup(
                    title: localizations.settingsProfilesTitle,
                    subtitle: localizations.settingsProfilesSubtitle,
                    profiles: widget.viewModel.profiles,
                    selectedProfile: widget.viewModel.activeProfile,
                    onNewProfile: () => _showCreateProfileModal(context),
                    onModifyProfile: (profile) =>
                        _showModifyProfileModal(context, profile),
                    onRemoveProfile: (profile) => unawaited(
                      widget.viewModel.removeProfile.execute(profile),
                    ),
                    onSwitchProfile: (profile) => {
                      if (profile != null)
                        unawaited(
                          widget.viewModel.switchProfile.execute(profile),
                        ),
                    },
                  ),
                  SettingsRadioGroup<ThemeMode>(
                    title: localizations.settingsThemeTitle,
                    subtitle: localizations.settingsThemeSubtitle,
                    options: widget.viewModel.availableThemes,
                    optionLabels: widget.viewModel.availableThemes
                        .map((e) => mapThemeModeToString(context, e))
                        .toList(),
                    selectedOption: widget.viewModel.theme,
                    onChanged: (theme) {
                      if (theme != null) {
                        unawaited(widget.viewModel.updateTheme.execute(theme));
                      }
                    },
                  ),
                  SettingsRadioGroup<String>(
                    title: localizations.settingsLanguageTitle,
                    subtitle: localizations.settingsLanguageSubtitle,
                    options: widget.viewModel.availableLocales
                        .map((e) => e.languageCode)
                        .toList(),
                    optionLabels: widget.viewModel.availableLocales
                        .map(
                          (e) =>
                              mapLanguageCodeToString(context, e.languageCode),
                        )
                        .toList(),
                    selectedOption: widget.viewModel.language,
                    onChanged: (languageCode) {
                      if (languageCode != null) {
                        unawaited(
                          widget.viewModel.updateLanguage.execute(languageCode),
                        );
                      }
                    },
                  ),
                  const SettingsContacts(),
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
    String? nameErrorText;

    await showCustomModalSheet<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CustomModalSheet(
              listenable: widget.viewModel.createProfile,
              title: localizations.settingsCreateProfileTitle,
              actionLabel: localizations.settingsCreateProfileLabel,
              onAction: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  setState(
                    () => nameErrorText = localizations
                        .settingsValidationProfileNameCannotBeEmpty,
                  );
                  return;
                }
                setState(() => nameErrorText = null);
                await widget.viewModel.createProfile.execute(
                  name,
                  descriptionController.text,
                );
                if (widget.viewModel.createProfile.completed &&
                    context.mounted) {
                  widget.viewModel.createProfile.clearResult();
                  Navigator.of(context).pop();
                }
              },
              isLoading: widget.viewModel.createProfile.running,
              childrenBuilder: (context) => [
                CustomTextField(
                  controller: nameController,
                  hintText: localizations.settingsCreateProfileSubtitle,
                  errorText: nameErrorText,
                ),
                CustomTextField(
                  controller: descriptionController,
                  hintText: localizations.settingsCreateProfileDescription,
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
    String? nameErrorText;

    await showCustomModalSheet<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CustomModalSheet(
              listenable: widget.viewModel.modifyProfile,
              title: localizations.settingsModifyProfileTitle,
              actionLabel: localizations.settingsModifyProfileLabel,
              onAction: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  setState(
                    () => nameErrorText = localizations
                        .settingsValidationProfileNameCannotBeEmpty,
                  );
                  return;
                }
                setState(() => nameErrorText = null);
                await widget.viewModel.modifyProfile.execute(
                  profile.copyWith(
                    name: name,
                    description: Value(
                      descriptionController.text.isNotEmpty
                          ? descriptionController.text
                          : null,
                    ),
                    isDefault: isDefaultController.value,
                  ),
                );
                if (widget.viewModel.modifyProfile.completed &&
                    context.mounted) {
                  widget.viewModel.modifyProfile.clearResult();
                  Navigator.of(context).pop();
                }
              },
              isLoading: widget.viewModel.modifyProfile.running,
              childrenBuilder: (context) => [
                CustomTextField(
                  controller: nameController,
                  hintText: localizations.settingsCreateProfileSubtitle,
                  errorText: nameErrorText,
                ),
                CustomTextField(
                  controller: descriptionController,
                  hintText: localizations.settingsCreateProfileDescription,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: isDefaultController,
                  builder: (context, isDefault, _) {
                    return CustomSwitch(
                      label: localizations.settingsModifyProfileIsDefaultLabel,
                      value: isDefault,
                      onChanged: profile.isDefault
                          ? null
                          : (value) => isDefaultController.value = value,
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

  void _onCreateProfileResult() {
    final localizations = AppLocalizations.of(context)!;
    showFeedbackOnResult(
      context: context,
      action: widget.viewModel.createProfile,
      successMessage: localizations.settingsProfileCreated,
      errorMessage: localizations.errorWhileCreatingProfile,
    );
  }

  void _onModifyProfileResult() {
    final localizations = AppLocalizations.of(context)!;
    showFeedbackOnResult(
      context: context,
      action: widget.viewModel.modifyProfile,
      successMessage: localizations.settingsProfileModified,
      errorMessage: localizations.errorWhileModifyingProfile,
    );
  }

  void _onRemoveProfileResult() {
    final localizations = AppLocalizations.of(context)!;
    showFeedbackOnResult(
      context: context,
      action: widget.viewModel.removeProfile,
      successMessage: localizations.settingsProfileRemoved,
      errorMessage: localizations.errorWhileRemovingProfile,
    );
  }
}
