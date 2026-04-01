import 'package:flutter/material.dart';

import '../../../data/database/database.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../utils/datetime.dart';
import '../../core/widgets/widgets.dart';

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

    return CustomCard(
      headline: source.profileId.toString(),
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
      title: source.title,
      description: descriptionOrPlaceholder,
      metadata: [
        source.url,
        if (source.lastSyncedAt != null)
          AppDateFormat.dateTime.format(source.lastSyncedAt!)
        else
          localizations.sourceCardNotSyncedYetLabel,
      ],
    );
  }
}
