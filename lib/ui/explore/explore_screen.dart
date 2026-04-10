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

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key, required this.viewModel});

  final ExploreViewModel viewModel;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.subscribeToSource.addListener(_onSubscribeToSourceResult);
  }

  @override
  void didUpdateWidget(covariant ExploreScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.subscribeToSource.removeListener(
      _onSubscribeToSourceResult,
    );
    widget.viewModel.subscribeToSource.addListener(_onSubscribeToSourceResult);
  }

  @override
  void dispose() {
    widget.viewModel.subscribeToSource.removeListener(
      _onSubscribeToSourceResult,
    );
    super.dispose();
  }

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
            onTap: widget.viewModel.load.execute,
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
              listenable: widget.viewModel.load,
              builder: (context, child) {
                if (widget.viewModel.load.completed) {
                  return child!;
                } else if (widget.viewModel.load.running) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ErrorIndicator(
                    title: localizations.exploreLoadErrorTitle,
                    label: localizations.exploreLoadErrorLabel,
                    onPressed: widget.viewModel.load.execute,
                  );
                }
              },
              child: ListenableBuilder(
                listenable: widget.viewModel,
                builder: (context, child) {
                  return widget.viewModel.filteredRecommendations.isNotEmpty
                      ? ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.paddingMedium,
                          ),
                          itemCount:
                              widget.viewModel.filteredRecommendations.length +
                              1,
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
                          separatorBuilder: (context, index) =>
                              const CustomDivider(),
                        )
                      : Center(
                          child: Text(
                            widget.viewModel.sourceRecommendations.isEmpty
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
    final recommendation = widget.viewModel.filteredRecommendations[index];
    return SourceRecommendationCard(
      recommendation: recommendation,
      subscribed: widget.viewModel.subscribedSources.any(
        (s) => s.url == recommendation.url,
      ),
      onSubscribe: () =>
          widget.viewModel.subscribeToSource.execute(recommendation.url),
    );
  }

  Future<void> _showFiltersModal(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    await showCustomModalSheet<void>(
      context: context,
      builder: (context) {
        return CustomModalSheet(
          listenable: widget.viewModel,
          title: localizations.filtersTitle,
          actionLabel: localizations.filtersActionLabel,
          onAction: widget.viewModel.clearFilters,
          childrenBuilder: (context) => [
            CustomFilterChips(
              label: localizations.exploreFiltersLanguageLabel,
              selected: widget.viewModel.selectedLanguages,
              options: widget.viewModel.availableLanguages,
              onOptionSelected: widget.viewModel.toggleLanguageFilter,
              optionLabelBuilder: (option) =>
                  mapLanguageCodeToString(context, option),
            ),
            CustomFilterChips(
              label: localizations.exploreFiltersCountryLabel,
              selected: widget.viewModel.selectedCountries,
              options: widget.viewModel.availableCountries,
              onOptionSelected: widget.viewModel.toggleCountryFilter,
            ),
            CustomFilterChips(
              label: localizations.exploreFiltersCategoryLabel,
              selected: widget.viewModel.selectedCategories,
              options: widget.viewModel.availableCategories,
              onOptionSelected: widget.viewModel.toggleCategoryFilter,
              optionLabelBuilder: (option) =>
                  mapCategoryToString(context, option),
            ),
            CustomFilterChips(
              label: localizations.exploreFiltersGenreTypeLabel,
              selected: widget.viewModel.selectedGenres,
              options: widget.viewModel.availableGenres,
              onOptionSelected: widget.viewModel.toggleGenreFilter,
              optionLabelBuilder: (option) => mapGenreToString(context, option),
            ),
            CustomSwitch(
              label: localizations.exploreFiltersShowSubscribedSourcesLabel,
              value: widget.viewModel.showSubscribed,
              onChanged: (_) => widget.viewModel.toggleShowSubscribed(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSubscribeToCustomSourceModal(BuildContext context) async {
    final urlController = TextEditingController();
    final localizations = AppLocalizations.of(context)!;
    String? errorText;

    await showCustomModalSheet<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CustomModalSheet(
              listenable: widget.viewModel.subscribeToSource,
              title: localizations.exploreAddCustomSourceTitle,
              description: localizations.exploreAddCustomSourceDescription,
              actionLabel: localizations.exploreAddCustomSourceActionLabel,
              onAction: () async {
                final input = urlController.text.trim();
                if (input.isEmpty) {
                  setState(
                    () => errorText =
                        localizations.exploreValidationUrlCannotBeEmpty,
                  );
                  return;
                }
                final uri = Uri.tryParse(input);
                if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
                  setState(
                    () => errorText = localizations.exploreValidationUrlInvalid,
                  );
                  return;
                }
                setState(() => errorText = null);
                await widget.viewModel.subscribeToSource.execute(input);
                if (widget.viewModel.subscribeToSource.completed &&
                    context.mounted) {
                  widget.viewModel.subscribeToSource.clearResult();
                  Navigator.of(context).pop();
                }
              },
              isLoading: widget.viewModel.subscribeToSource.running,
              childrenBuilder: (context) => [
                CustomTextField(
                  controller: urlController,
                  hintText: localizations.exploreAddCustomSourceSubtitle,
                  errorText: errorText,
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _onSubscribeToSourceResult() {
    final localizations = AppLocalizations.of(context)!;
    showFeedbackOnResult(
      context: context,
      action: widget.viewModel.subscribeToSource,
      successMessage: localizations.sourceSubscribed,
      errorMessage: localizations.errorWhileSubscribingToSource,
    );
  }
}
