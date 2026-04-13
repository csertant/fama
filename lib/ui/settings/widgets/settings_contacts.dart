import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../core/themes/dimensions.dart';
import '../../core/widgets/widgets.dart';

class SettingsContacts extends StatelessWidget {
  const SettingsContacts({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  localizations.settingsContactTitle,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              CustomIconButton.redirectExternal(
                icon: CustomIcons.sendMail,
                url: 'mailto:nosebitestudios@gmail.com',
                tooltip: localizations.settingsContactEmailLabel,
              ),
            ],
          ),
          Text(
            localizations.settingsContactSubtitle,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
