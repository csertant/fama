import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../core/themes/dimensions.dart';
import '../core/widgets/widgets.dart';
import 'saved_viewmodel.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key, required this.viewModel});

  final SavedViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.savedTitle,
        actions: [
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
              title: localizations.savedLoadErrorTitle,
              label: localizations.savedLoadErrorLabel,
              onPressed: viewModel.load.execute,
            );
          }
        },
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            return viewModel.savedArticles.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.paddingMedium,
                    ),
                    itemCount: viewModel.savedArticles.length,
                    itemBuilder: _buildArticleCard,
                  )
                : Center(
                    child: Text(
                      localizations.savedEmptyLabel,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
          },
        ),
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, int index) {
    final article = viewModel.savedArticles[index];
    return ArticleCard.leadingImage(
      article: article,
      onConfirmDismissArticle: (direction) => Future.value(true),
      dismissibleActionLeft: CustomDismissibleAction.left(
        icon: CustomIcons.remove,
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
      dismissibleActionRight: const CustomDismissibleAction.right(
        icon: CustomIcons.read,
      ),
    );
  }
}
