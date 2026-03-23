import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
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
          CustomIconButton.normal(icon: CustomIcons.read, onTap: () {}),
          CustomIconButton.normal(icon: CustomIcons.filter, onTap: () {}),
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
            return viewModel.articles.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.paddingMedium,
                    ),
                    itemCount: viewModel.articles.length,
                    itemBuilder: _buildArticleCard,
                  )
                : Center(
                    child: Text(
                      localizations.feedEmptyLabel,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
          },
        ),
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, int index) {
    final article = viewModel.articles[index];
    return ArticleCard.headingImage(
      article: article,
      onConfirmDismissArticle: (direction) => Future.value(true),
      dismissibleActionLeft: CustomDismissibleAction.left(
        icon: CustomIcons.saved,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      dismissibleActionRight: const CustomDismissibleAction.right(
        icon: CustomIcons.read,
      ),
    );
  }
}
