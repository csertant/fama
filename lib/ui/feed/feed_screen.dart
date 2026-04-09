import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/services/connectivity_service/connectivity_service.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../l10n/utils.dart';
import '../core/themes/colors.dart';
import '../core/themes/dimensions.dart';
import '../core/widgets/widgets.dart';
import 'feed_viewmodel.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key, required this.viewModel});

  final FeedViewModel viewModel;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.markAsRead.addListener(_onMarkAsReadResult);
    widget.viewModel.markAsSaved.addListener(_onMarkAsSavedResult);
  }

  @override
  void didUpdateWidget(covariant FeedScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.markAsRead.removeListener(_onMarkAsReadResult);
    widget.viewModel.markAsRead.addListener(_onMarkAsReadResult);
    oldWidget.viewModel.markAsSaved.removeListener(_onMarkAsSavedResult);
    widget.viewModel.markAsSaved.addListener(_onMarkAsSavedResult);
  }

  @override
  void dispose() {
    widget.viewModel.markAsRead.removeListener(_onMarkAsReadResult);
    widget.viewModel.markAsSaved.removeListener(_onMarkAsSavedResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final connectivityService = context.watch<ConnectivityService>();
    return Scaffold(
      appBar: CustomAppBar(
        leading: const CustomIcon(
          iconPath: CustomIcons.appIcon,
          size: AppDimensions.iconSizeMedium,
        ),
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
                    title: localizations.feedLoadErrorTitle,
                    label: localizations.feedLoadErrorLabel,
                    onPressed: widget.viewModel.load.execute,
                  );
                }
              },
              child: ListenableBuilder(
                listenable: widget.viewModel,
                builder: (context, child) {
                  return widget.viewModel.filteredArticles.isNotEmpty
                      ? ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.paddingMedium,
                          ),
                          itemCount: widget.viewModel.filteredArticles.length,
                          itemBuilder: _buildArticleCard,
                        )
                      : Center(
                          child: Text(
                            widget.viewModel.articles.isEmpty
                                ? localizations.feedEmptyLabel
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
    final article = widget.viewModel.filteredArticles[index];
    return ArticleCard.headingImage(
      article: article,
      onConfirmDismissArticle: (direction) async {
        switch (direction) {
          case DismissDirection.startToEnd:
            await widget.viewModel.markAsSaved.execute(article);
            return false;
          case DismissDirection.endToStart:
            await widget.viewModel.markAsRead.execute(article);
            if (widget.viewModel.markAsRead.completed) {
              return !widget.viewModel.showRead;
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
          listenable: widget.viewModel,
          title: localizations.filtersTitle,
          actionLabel: localizations.filtersActionLabel,
          onAction: widget.viewModel.clearFilters,
          childrenBuilder: (context) => [
            CustomFilter(
              label: localizations.feedFiltersSourcesLabel,
              selected: widget.viewModel.selectedSources,
              options: widget.viewModel.availableSources,
              onOptionSelected: widget.viewModel.toggleSourceFilter,
            ),
            CustomFilter(
              label: localizations.feedFiltersAuthorsLabel,
              selected: widget.viewModel.selectedAuthors,
              options: widget.viewModel.availableAuthors,
              onOptionSelected: widget.viewModel.toggleAuthorFilter,
            ),
            CustomFilter(
              label: localizations.feedFiltersDurationLabel,
              selected: [widget.viewModel.selectedDuration],
              options: FilterDuration.all,
              onOptionSelected: widget.viewModel.setDuration,
              optionLabelBuilder: (option) =>
                  mapDurationToString(context, option),
            ),
            CustomFilter(
              label: localizations.feedFiltersLimitLabel,
              selected: [widget.viewModel.selectedLimit],
              options: FilterLimit.all,
              onOptionSelected: widget.viewModel.setLimit,
            ),
            CustomSwitch(
              label: localizations.feedFiltersShowReadArticlesLabel,
              value: widget.viewModel.showRead,
              onChanged: (_) => widget.viewModel.toggleShowRead(),
            ),
          ],
        );
      },
    );
  }

  void _onMarkAsReadResult() {
    final localizations = AppLocalizations.of(context)!;
    showFeedbackOnResult(
      context: context,
      action: widget.viewModel.markAsRead,
      successMessage: localizations.articleMarkedAsRead,
      errorMessage: localizations.errorWhileMarkingArticleAsRead,
    );
  }

  void _onMarkAsSavedResult() {
    final localizations = AppLocalizations.of(context)!;
    showFeedbackOnResult(
      context: context,
      action: widget.viewModel.markAsSaved,
      successMessage: localizations.articleMarkedAsSaved,
      errorMessage: localizations.errorWhileSavingArticle,
    );
  }
}
