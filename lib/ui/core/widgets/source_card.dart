import 'package:flutter/material.dart';

import '../../../data/database/database.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../utils/datetime.dart';
import '../themes/dimensions.dart';
import 'widgets.dart';

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
    final descriptionOrPlaceholder =
        source.description != null && source.description!.isNotEmpty
        ? source.description!
        : localizations.sourceCardNoDescriptionLabel;

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      //TODO: examine if we can place this into CustomCard
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppDimensions.paddingSmall,
        children: [
          CustomTextWithActions(
            //TODO: use profile name
            text: source.profileId.toString(),
            actions: [
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
          CustomTextTitleWithSummary(
            title: source.title,
            summary: descriptionOrPlaceholder,
          ),
          CustomTextMetadata(
            leftText: source.url,
            rightText: source.lastSyncedAt != null
                ? AppDateFormat.dateTime.format(source.lastSyncedAt!)
                : localizations.sourceCardNotSyncedYetLabel,
          ),
        ],
      ),
    );
  }
}
