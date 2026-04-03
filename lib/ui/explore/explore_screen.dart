import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../core/themes/dimensions.dart';
import '../core/widgets/custom_modal_sheet.dart';
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
                    itemCount: viewModel.sourceRecommendations.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingMedium,
                          ),
                          child: SourceByCustomUrlCard(
                            title: localizations.exploreAddCustomSourceTitle,
                            onSubscribe: () =>
                                _showSubscribeToCustomSourceModal(context),
                          ),
                        );
                      }
                      return _buildRecommendationCard(context, index - 1);
                    },
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

  Future<void> _showSubscribeToCustomSourceModal(BuildContext context) async {
    final urlController = TextEditingController();
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.borderRadiusMedium),
        ),
      ),
      builder: (context) {
        return AnimatedBuilder(
          animation: viewModel.subscribeToSource,
          builder: (context, _) {
            return CustomModalSheet(
              title: localizations.exploreAddCustomSourceTitle,
              description: localizations.exploreAddCustomSourceDescription,
              actionLabel: localizations.exploreAddCustomSourceActionLabel,
              onAction: () async {
                if (urlController.text.isNotEmpty) {
                  await viewModel.subscribeToSource.execute(urlController.text);
                  if (viewModel.subscribeToSource.completed &&
                      context.mounted) {
                    viewModel.subscribeToSource.clearResult();
                    Navigator.of(context).pop();
                  }
                }
              },
              isLoading: viewModel.subscribeToSource.running,
              children: [
                TextField(
                  controller: urlController,
                  decoration: InputDecoration(
                    hintText: localizations.exploreAddCustomSourceSubtitle,
                    hintStyle: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
