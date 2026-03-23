import 'package:flutter/material.dart';

import '../../../data/database/database.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../utils/utils.dart';
import '../themes/dimensions.dart';
import 'widgets.dart';

enum ArticleCardLayout { leadingImage, headingImage, normal }

class ArticleCard extends StatelessWidget {
  const ArticleCard.leadingImage({
    super.key,
    required this.article,
    this.sourceTitle,
    required this.onConfirmDismissArticle,
    required this.dismissibleActionLeft,
    required this.dismissibleActionRight,
  }) : layout = ArticleCardLayout.leadingImage;

  const ArticleCard.headingImage({
    super.key,
    required this.article,
    this.sourceTitle,
    required this.onConfirmDismissArticle,
    required this.dismissibleActionLeft,
    required this.dismissibleActionRight,
  }) : layout = ArticleCardLayout.headingImage;

  const ArticleCard.normal({
    super.key,
    required this.article,
    this.sourceTitle,
    required this.onConfirmDismissArticle,
    required this.dismissibleActionLeft,
    required this.dismissibleActionRight,
  }) : layout = ArticleCardLayout.normal;

  final Article article;
  final ArticleCardLayout layout;
  final String? sourceTitle;

  final ConfirmDismissCallback onConfirmDismissArticle;

  final CustomDismissibleAction dismissibleActionLeft;
  final CustomDismissibleAction dismissibleActionRight;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(article.id),
      confirmDismiss: onConfirmDismissArticle,
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
    final summaryOrPlaceholder = article.summary != null
        ? article.summary!
        : localizations.articleCardNoSummaryLabel;
    //TODO: real source name
    final sourceOrPlaceholder = sourceTitle ?? 'Source #${article.sourceId}';
    final authorOrPlaceholder = article.author != null
        ? article.author!
        : localizations.articleCardNoAuthorLabel;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppDimensions.paddingSmall,
      children: [
        CustomTextWithActions(
          text: sourceOrPlaceholder,
          actions: [
            CustomIconButton.normal(onTap: () {}, icon: CustomIcons.share),
          ],
        ),
        CustomTextTitleWithSummary(
          title: article.title,
          summary: summaryOrPlaceholder,
        ),
        CustomTextMetadata(
          leftText: authorOrPlaceholder,
          rightText: AppDateFormat.dateTime.format(article.publishedAt),
        ),
      ],
    );
  }
}
