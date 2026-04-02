import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../core/themes/dimensions.dart';
import '../core/widgets/widgets.dart';
import 'explore_viewmodel.dart';
import 'widgets/source_recommendation_card.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key, required this.viewModel});

  final ExploreViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.exploreTitle,
        actions: [
          CustomIconButton.normal(
            icon: CustomIcons.filter,
            onTap: () {},
            tooltip: localizations.navigationLabelFilter,
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewModel.load,
        builder: (context, child) {
          if (viewModel.load.completed) {
            return child!;
          } else if (viewModel.load.running) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ErrorIndicator(
              title: localizations.exploreLoadErrorTitle,
              label: localizations.exploreLoadErrorLabel,
              onPressed: viewModel.load.execute,
            );
          }
        },
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            return viewModel.sourceRecommendations.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.paddingMedium,
                    ),
                    itemCount: viewModel.sourceRecommendations.length,
                    itemBuilder: _buildRecommendationCard,
                  )
                : Center(
                    child: Text(
                      localizations.exploreEmptyLabel,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
          },
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(BuildContext context, int index) {
    final recommendation = viewModel.sourceRecommendations[index];
    return SourceRecommendationCard(
      recommendation: recommendation,
      subscribed: viewModel.subscribedSources.any(
        (s) => s.url == recommendation.url,
      ),
      onSubscribe: () =>
          viewModel.subscribeToSource.execute(recommendation.url),
    );
  }
}
