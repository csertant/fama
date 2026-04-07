import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/services/connectivity_service/connectivity_service.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../l10n/utils.dart';
import '../core/themes/dimensions.dart';
import '../core/widgets/widgets.dart';
import 'saved_viewmodel.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key, required this.viewModel});

  final SavedViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final connectivityService = context.watch<ConnectivityService>();
    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.savedTitle,
        actions: [
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
                    title: localizations.savedLoadErrorTitle,
                    label: localizations.savedLoadErrorLabel,
                    onPressed: viewModel.load.execute,
                  );
                }
              },
              child: ListenableBuilder(
                listenable: viewModel,
                builder: (context, child) {
                  return viewModel.filteredSavedArticles.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.paddingMedium,
                          ),
                          itemCount: viewModel.filteredSavedArticles.length,
                          itemBuilder: _buildArticleCard,
                        )
                      : Center(
                          child: Text(
                            viewModel.savedArticles.isEmpty
                                ? localizations.savedEmptyLabel
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

  Widget _buildArticleCard(BuildContext context, int index) {
    final article = viewModel.filteredSavedArticles[index];
    return ArticleCard.leadingImage(
      article: article,
      onConfirmDismissArticle: (direction) async {
        switch (direction) {
          case DismissDirection.startToEnd:
            await viewModel.markAsUnsaved.execute(article);
            if (viewModel.markAsUnsaved.completed) {
              return true;
            } else {
              return false;
            }
          case DismissDirection.endToStart:
            await viewModel.markAsRead.execute(article);
            if (viewModel.markAsRead.completed) {
              return true;
            } else {
              return false;
            }
          case DismissDirection.up:
          case DismissDirection.down:
          case DismissDirection.horizontal:
          case DismissDirection.vertical:
          case DismissDirection.none:
            return false;
        }
      },
      dismissibleActionLeft: CustomDismissibleAction.left(
        icon: CustomIcons.remove,
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
      dismissibleActionRight: const CustomDismissibleAction.right(
        icon: CustomIcons.read,
      ),
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
              label: localizations.feedFiltersSourcesLabel,
              selected: viewModel.selectedSources,
              options: viewModel.availableSources,
              onOptionSelected: viewModel.toggleSourceFilter,
            ),
            CustomFilter(
              label: localizations.feedFiltersAuthorsLabel,
              selected: viewModel.selectedAuthors,
              options: viewModel.availableAuthors,
              onOptionSelected: viewModel.toggleAuthorFilter,
            ),
            CustomFilter(
              label: localizations.feedFiltersDurationLabel,
              selected: [viewModel.selectedDuration],
              options: FilterDuration.all,
              onOptionSelected: viewModel.setDuration,
              optionLabelBuilder: (option) =>
                  mapDurationToString(context, option),
            ),
            CustomSwitch(
              label: localizations.feedFiltersShowReadArticlesLabel,
              value: viewModel.showRead,
              onChanged: (_) => viewModel.toggleShowRead(),
            ),
          ],
        );
      },
    );
  }
}
