import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/services/connectivity_service/connectivity_service.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../l10n/utils.dart';
import '../core/themes/dimensions.dart';
import '../core/widgets/widgets.dart';
import 'explore_viewmodel.dart';
import 'widgets/source_by_custom_url_card.dart';
import 'widgets/source_recommendation_card.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key, required this.viewModel});

  final ExploreViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final connectivityService = context.watch<ConnectivityService>();
    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.exploreTitle,
        actions: [
          CustomIconButton.normal(
            icon: CustomIcons.refresh,
            onTap: viewModel.load.execute,
            tooltip: localizations.navigationLabelRefresh,
          ),
          CustomIconButton.normal(
            icon: CustomIcons.filter,
            onTap: () => _showFiltersModal(context),
            tooltip: localizations.navigationLabelFilter,
          ),
        ],
      ),
      body: Column(
        children: [
          if (connectivityService.isOffline)
            CustomErrorBanner(message: localizations.noInternetConnectionTitle),
          Expanded(
            child: ListenableBuilder(
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
                  return viewModel.filteredRecommendations.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.paddingMedium,
                          ),
                          itemCount:
                              viewModel.filteredRecommendations.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimensions.paddingMedium,
                                ),
                                child: SourceByCustomUrlCard(
                                  title:
                                      localizations.exploreAddCustomSourceTitle,
                                  onSubscribe: () =>
                                      _showSubscribeToCustomSourceModal(
                                        context,
                                      ),
                                ),
                              );
                            }
                            return _buildRecommendationCard(context, index - 1);
                          },
                        )
                      : Center(
                          child: Text(
                            viewModel.sourceRecommendations.isEmpty
                                ? localizations.exploreEmptyLabel
                                : localizations.filtersNoMatchesLabel,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(BuildContext context, int index) {
    final recommendation = viewModel.filteredRecommendations[index];
    return SourceRecommendationCard(
      recommendation: recommendation,
      subscribed: viewModel.subscribedSources.any(
        (s) => s.url == recommendation.url,
      ),
      onSubscribe: () =>
          viewModel.subscribeToSource.execute(recommendation.url),
    );
  }

  Future<void> _showFiltersModal(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    await showCustomModalSheet<void>(
      context: context,
      builder: (context) {
        return CustomModalSheet(
          listenable: viewModel,
          title: localizations.filtersTitle,
          actionLabel: localizations.filtersActionLabel,
          onAction: viewModel.clearFilters,
          childrenBuilder: (context) => [
            CustomFilter(
              label: localizations.exploreFiltersLanguageLabel,
              selected: viewModel.selectedLanguages,
              options: viewModel.availableLanguages,
              onOptionSelected: viewModel.toggleLanguageFilter,
              optionLabelBuilder: (option) =>
                  mapLanguageCodeToString(context, option),
            ),
            CustomFilter(
              label: localizations.exploreFiltersCountryLabel,
              selected: viewModel.selectedCountries,
              options: viewModel.availableCountries,
              onOptionSelected: viewModel.toggleCountryFilter,
            ),
            CustomFilter(
              label: localizations.exploreFiltersCategoryLabel,
              selected: viewModel.selectedCategories,
              options: viewModel.availableCategories,
              onOptionSelected: viewModel.toggleCategoryFilter,
            ),
            CustomSwitch(
              label: localizations.exploreFiltersShowSubscribedSourcesLabel,
              value: viewModel.showSubscribed,
              onChanged: (_) => viewModel.toggleShowSubscribed(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSubscribeToCustomSourceModal(BuildContext context) async {
    final urlController = TextEditingController();
    final localizations = AppLocalizations.of(context)!;
    await showCustomModalSheet<void>(
      context: context,
      builder: (context) {
        return CustomModalSheet(
          listenable: viewModel.subscribeToSource,
          title: localizations.exploreAddCustomSourceTitle,
          description: localizations.exploreAddCustomSourceDescription,
          actionLabel: localizations.exploreAddCustomSourceActionLabel,
          onAction: () async {
            if (urlController.text.isNotEmpty) {
              await viewModel.subscribeToSource.execute(urlController.text);
              if (viewModel.subscribeToSource.completed && context.mounted) {
                viewModel.subscribeToSource.clearResult();
                Navigator.of(context).pop();
              }
            }
          },
          isLoading: viewModel.subscribeToSource.running,
          childrenBuilder: (context) => [
            CustomTextField(
              controller: urlController,
              hintText: localizations.exploreAddCustomSourceSubtitle,
            ),
          ],
        );
      },
    );
  }
}
