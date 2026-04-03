import 'package:flutter/material.dart';

import '../../../data/services/remote_data_service/models.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../core/widgets/widgets.dart';

class SourceRecommendationCard extends StatelessWidget {
  const SourceRecommendationCard({
    super.key,
    required this.recommendation,
    required this.subscribed,
    required this.onSubscribe,
  });

  final SourceRecommendation recommendation;
  final bool subscribed;
  final VoidCallback onSubscribe;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final descriptionOrPlaceholder =
        recommendation.description != null &&
            recommendation.description!.isNotEmpty
        ? recommendation.description!
        : localizations.sourceRecommendationCardNoDescriptionLabel;
    return CustomCard(
      headline: recommendation.url,
      actions: [
        CustomIconButton.normal(
          onTap: onSubscribe,
          icon: subscribed ? CustomIcons.checked : CustomIcons.check,
          enabled: !subscribed,
          tooltip: subscribed
              ? localizations.sourceRecommendationCardLabelSubscribed
              : localizations.sourceRecommendationCardLabelSubscribe,
        ),
      ],
      title: recommendation.name,
      titleUrl: recommendation.siteUrl,
      description: descriptionOrPlaceholder,
      metadata: [
        if (subscribed) localizations.sourceRecommendationCardLabelSubscribed,
      ],
    );
  }
}
