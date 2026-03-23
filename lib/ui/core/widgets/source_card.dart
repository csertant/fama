import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/database/database.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../themes/dimensions.dart';
import 'custom_icon.dart';
import 'custom_icon_button.dart';

class SourceCard extends StatelessWidget {
  const SourceCard({
    super.key,
    required this.source,
    required this.onModifySource,
    required this.onRemoveSource,
  });

  final Source source;

  final VoidCallback onModifySource;
  final VoidCallback onRemoveSource;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final descriptionOrPlaceholder =
        source.description != null && source.description!.isNotEmpty
        ? source.description!
        : localizations.sourceCardNoDescriptionLabel;
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(source.title, style: theme.textTheme.titleMedium),
              ),
              CustomIconButton.normal(
                onTap: onModifySource,
                icon: CustomIcons.modify,
              ),
              CustomIconButton.normal(
                onTap: onRemoveSource,
                icon: CustomIcons.remove,
              ),
            ],
          ),
          Text(descriptionOrPlaceholder, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppDimensions.paddingSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(source.url, style: theme.textTheme.labelMedium),
              Text(
                source.lastSyncedAt != null
                    ? localizations.sourceCardLastSyncLabel(
                        DateFormat(
                          'y. MM. dd. HH:mm:ss',
                        ).format(source.lastSyncedAt!),
                      )
                    : localizations.sourceCardNotSyncedYetLabel,
                style: theme.textTheme.labelMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
