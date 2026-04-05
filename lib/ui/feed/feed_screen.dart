import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../l10n/utils.dart';
import '../core/themes/colors.dart';
import '../core/themes/dimensions.dart';
import '../core/widgets/widgets.dart';
import 'feed_viewmodel.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key, required this.viewModel});

  final FeedViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        leading: const CustomIcon(
          iconPath: CustomIcons.appIcon,
          size: AppDimensions.iconSizeMedium,
        ),
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
      body: ListenableBuilder(
        listenable: viewModel.load,
        builder: (context, child) {
          if (viewModel.load.completed) {
            return child!;
          } else if (viewModel.load.running) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ErrorIndicator(
              title: localizations.feedLoadErrorTitle,
              label: localizations.feedLoadErrorLabel,
              onPressed: viewModel.load.execute,
            );
          }
        },
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            return viewModel.filteredArticles.isNotEmpty
                ? ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.paddingMedium,
                    ),
                    itemCount: viewModel.filteredArticles.length,
                    itemBuilder: _buildArticleCard,
                  )
                : Center(
                    child: Text(
                      viewModel.articles.isEmpty
                          ? localizations.feedEmptyLabel
                          : localizations.filtersNoMatchesLabel,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
          },
        ),
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, int index) {
    final article = viewModel.filteredArticles[index];
    return ArticleCard.headingImage(
      article: article,
      onConfirmDismissArticle: (direction) async {
        switch (direction) {
          case DismissDirection.startToEnd:
            await viewModel.markAsSaved.execute(article);
            if (viewModel.markAsSaved.completed) {
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
      dismissibleActionLeft: const CustomDismissibleAction.left(
        icon: CustomIcons.saved,
        backgroundColor: AppColors.green,
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
            CustomFilter(
              label: localizations.feedFiltersLimitLabel,
              selected: [viewModel.selectedLimit],
              options: FilterLimit.all,
              onOptionSelected: viewModel.setLimit,
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
