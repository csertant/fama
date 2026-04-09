import 'package:flutter/material.dart';

import '../../../data/database/database.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../core/themes/dimensions.dart';
import '../../core/widgets/widgets.dart';

class SettingsProfilesGroup extends StatelessWidget {
  const SettingsProfilesGroup({
    super.key,
    required this.title,
    required this.subtitle,
    required this.profiles,
    required this.selectedProfile,
    required this.onNewProfile,
    required this.onModifyProfile,
    required this.onRemoveProfile,
    required this.onSwitchProfile,
  });

  final String title;
  final String subtitle;
  final List<Profile> profiles;
  final Profile selectedProfile;
  final VoidCallback onNewProfile;
  final ValueChanged<Profile> onModifyProfile;
  final ValueChanged<Profile> onRemoveProfile;
  final ValueChanged<Profile?> onSwitchProfile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      child: RadioGroup<Profile>(
        onChanged: onSwitchProfile,
        groupValue: selectedProfile,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
                CustomIconButton.normal(
                  icon: CustomIcons.add,
                  onTap: onNewProfile,
                  tooltip: localizations.settingsProfilesCardLabelAdd,
                ),
              ],
            ),
            Text(subtitle, style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppDimensions.paddingMedium),
            ...profiles.map(
              (profile) => RadioListTile<Profile>(
                contentPadding: EdgeInsets.zero,
                value: profile,
                title: Text(profile.name),
                subtitle: profile.description != null
                    ? Text(profile.description!)
                    : null,
                secondary: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconButton.normal(
                      icon: CustomIcons.modify,
                      onTap: () => onModifyProfile(profile),
                      tooltip: localizations.settingsProfilesCardLabelModify,
                    ),
                    CustomIconButton.normal(
                      icon: CustomIcons.remove,
                      onTap: () => onRemoveProfile(profile),
                      tooltip: localizations.settingsProfilesCardLabelRemove,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
