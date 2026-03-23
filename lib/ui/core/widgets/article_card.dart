import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/database/database.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../themes/dimensions.dart';
import 'widgets.dart';

enum ArticleCardLayout { leadingImage, headingImage, normal }

class ArticleCard extends StatelessWidget {
  const ArticleCard.leadingImage({
    super.key,
    required this.article,
    this.sourceTitle,
    this.onDismissArticle,
    required this.onConfirmDismissArticle,
    required this.dismissibleActionLeft,
    required this.dismissibleActionRight,
  }) : layout = ArticleCardLayout.leadingImage;

  const ArticleCard.headingImage({
    super.key,
    required this.article,
    this.sourceTitle,
    this.onDismissArticle,
    required this.onConfirmDismissArticle,
    required this.dismissibleActionLeft,
    required this.dismissibleActionRight,
  }) : layout = ArticleCardLayout.headingImage;

  const ArticleCard.normal({
    super.key,
    required this.article,
    this.sourceTitle,
    this.onDismissArticle,
    required this.onConfirmDismissArticle,
    required this.dismissibleActionLeft,
    required this.dismissibleActionRight,
  }) : layout = ArticleCardLayout.normal;

  final Article article;
  final ArticleCardLayout layout;
  final String? sourceTitle;

  final void Function(DismissDirection)? onDismissArticle;
  final ConfirmDismissCallback onConfirmDismissArticle;

  final CustomDismissibleAction dismissibleActionLeft;
  final CustomDismissibleAction dismissibleActionRight;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(article.id),
      confirmDismiss: onConfirmDismissArticle,
      onDismissed: onDismissArticle,
      background: dismissibleActionLeft,
      secondaryBackground: dismissibleActionRight,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: _buildCard(context, layout),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, ArticleCardLayout layout) {
    const placeholder = CustomIcon(
      iconPath: CustomIcons.missingImage,
      size: AppDimensions.iconSizeMedium,
    );
    final imageOrPlaceholder = article.imageUrl != null
        ? Image.network(
            article.imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => placeholder,
          )
        : placeholder;

    switch (layout) {
      case ArticleCardLayout.leadingImage:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: AppDimensions.leadingImageWidth,
              child: imageOrPlaceholder,
            ),
            const SizedBox(width: AppDimensions.paddingMedium),
            Expanded(child: _buildTextContent(context)),
          ],
        );
      case ArticleCardLayout.headingImage:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: AppDimensions.headingImageHeight,
              child: imageOrPlaceholder,
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            _buildTextContent(context),
          ],
        );
      case ArticleCardLayout.normal:
        return _buildTextContent(context);
    }
  }

  Widget _buildTextContent(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final summaryOrPlaceholder = article.summary != null
        ? article.summary!
        : localizations.articleCardNoSummaryLabel;
    //TODO
    final sourceOrPlaceholder =
        sourceTitle ?? article.author ?? 'Source #${article.sourceId}';
    final publishedAtLabel = DateFormat(
      'y. MM. dd. HH:mm',
    ).format(article.publishedAt);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                sourceOrPlaceholder,
                style: theme.textTheme.labelMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingSmall),
            Text(publishedAtLabel, style: theme.textTheme.labelMedium),
          ],
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        Text(article.title, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppDimensions.paddingSmall),
        Text(
          summaryOrPlaceholder,
          style: theme.textTheme.bodyMedium,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
