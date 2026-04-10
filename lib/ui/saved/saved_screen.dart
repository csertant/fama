import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/services/connectivity_service/connectivity_service.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../l10n/utils.dart';
import '../core/themes/dimensions.dart';
import '../core/widgets/widgets.dart';
import 'saved_viewmodel.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key, required this.viewModel});

  final SavedViewModel viewModel;

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.markAsRead.addListener(_onMarkAsReadResult);
    widget.viewModel.markAsUnsaved.addListener(_onMarkAsUnSavedResult);
  }

  @override
  void didUpdateWidget(covariant SavedScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.markAsRead.removeListener(_onMarkAsReadResult);
    widget.viewModel.markAsRead.addListener(_onMarkAsReadResult);
    oldWidget.viewModel.markAsUnsaved.removeListener(_onMarkAsUnSavedResult);
    widget.viewModel.markAsUnsaved.addListener(_onMarkAsUnSavedResult);
  }

  @override
  void dispose() {
    widget.viewModel.markAsRead.removeListener(_onMarkAsReadResult);
    widget.viewModel.markAsUnsaved.removeListener(_onMarkAsUnSavedResult);
    super.dispose();
  }

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
              listenable: widget.viewModel.load,
              builder: (context, child) {
                if (widget.viewModel.load.completed) {
                  return child!;
                } else if (widget.viewModel.load.running) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ErrorIndicator(
                    title: localizations.savedLoadErrorTitle,
                    label: localizations.savedLoadErrorLabel,
                    onPressed: widget.viewModel.load.execute,
                  );
                }
              },
              child: ListenableBuilder(
                listenable: widget.viewModel,
                builder: (context, child) {
                  return widget.viewModel.filteredSavedArticles.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.paddingMedium,
                          ),
                          itemCount:
                              widget.viewModel.filteredSavedArticles.length,
                          itemBuilder: _buildArticleCard,
                        )
                      : Center(
                          child: Text(
                            widget.viewModel.savedArticles.isEmpty
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
    final article = widget.viewModel.filteredSavedArticles[index];
    return ArticleCard.headingImage(
      article: article,
      onConfirmDismissArticle: (direction) async {
        switch (direction) {
          case DismissDirection.startToEnd:
            await widget.viewModel.markAsUnsaved.execute(article);
            if (widget.viewModel.markAsUnsaved.completed) {
              return true;
            } else {
              return false;
            }
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
          listenable: widget.viewModel,
          title: localizations.filtersTitle,
          actionLabel: localizations.filtersActionLabel,
          onAction: widget.viewModel.clearFilters,
          childrenBuilder: (context) => [
            CustomFilterChips(
              label: localizations.feedFiltersSourcesLabel,
              selected: widget.viewModel.selectedSources,
              options: widget.viewModel.availableSources,
              onOptionSelected: widget.viewModel.toggleSourceFilter,
            ),
            CustomFilterChips(
              label: localizations.feedFiltersAuthorsLabel,
              selected: widget.viewModel.selectedAuthors,
              options: widget.viewModel.availableAuthors,
              onOptionSelected: widget.viewModel.toggleAuthorFilter,
            ),
            CustomFilterChips(
              label: localizations.feedFiltersDurationLabel,
              selected: [widget.viewModel.selectedDuration],
              options: FilterDuration.all,
              onOptionSelected: widget.viewModel.setDuration,
              optionLabelBuilder: (option) =>
                  mapDurationToString(context, option),
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

  void _onMarkAsUnSavedResult() {
    final localizations = AppLocalizations.of(context)!;
    showFeedbackOnResult(
      context: context,
      action: widget.viewModel.markAsUnsaved,
      successMessage: localizations.articleMarkedAsUnsaved,
      errorMessage: localizations.errorWhileUnSavingArticle,
    );
  }
}
