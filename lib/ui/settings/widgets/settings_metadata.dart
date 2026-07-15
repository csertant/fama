import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../core/themes/dimensions.dart';

class SettingsMetadata extends StatelessWidget {
  const SettingsMetadata({super.key, required this.versionString});

  final String versionString;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            localizations.settingsMetadataVersionLabel(versionString),
            style: theme.textTheme.bodySmall,
          ),
          Text(
            localizations.settingsMetadataLegalNotice,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
