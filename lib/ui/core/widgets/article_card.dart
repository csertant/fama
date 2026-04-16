import 'package:flutter/material.dart';

import '../../../data/database/database.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../utils/utils.dart';
import '../themes/dimensions.dart';
import 'widgets.dart';

enum ArticleCardLayout { leadingImage, headingImage, normal }

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    super.key,
    required this.article,
    required this.layout,
    required this.onConfirmDismissArticle,
    required this.dismissibleActionLeft,
    required this.dismissibleActionRight,
  });

  final Article article;
  final ArticleCardLayout layout;

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
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: _buildCard(context, layout),
      ),
    );
  }

  Widget _buildCard(BuildContext context, ArticleCardLayout layout) {
    final imageOrPlaceholder = CustomCachedNetworkImage(
      imageUrl: article.imageUrl ?? '',
      placeholderIconPath: CustomIcons.missingImage,
    );
    switch (layout) {
      case ArticleCardLayout.leadingImage:
        return LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = MediaQuery.sizeOf(context).width;
            final availableWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : screenWidth;
            final imageWidth =
                (availableWidth * AppDimensions.leadingImageWidthRatio).clamp(
                  AppDimensions.leadingImageMinWidth,
                  AppDimensions.leadingImageMaxWidth,
                );
            return Row(
              spacing: AppDimensions.paddingMedium,
              children: [
                SizedBox(width: imageWidth, child: imageOrPlaceholder),
                Expanded(child: _buildTextContent(context)),
              ],
            );
          },
        );
      case ArticleCardLayout.headingImage:
        return LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = MediaQuery.sizeOf(context).width;
            final imageWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : screenWidth;
            final imageHeight =
                imageWidth / AppDimensions.headingImageAspectRatio;
            return Column(
              spacing: AppDimensions.paddingSmall,
              children: [
                SizedBox(
                  width: imageWidth,
                  height: imageHeight,
                  child: imageOrPlaceholder,
                ),
                _buildTextContent(context),
              ],
            );
          },
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
    final authorOrPlaceholder = article.author != null
        ? article.author!
        : localizations.articleCardNoAuthorLabel;
    return CustomCard(
      padding: EdgeInsets.zero,
      headline: article.sourceName,
      actions: [
        CustomIconButton.normal(
          onTap: () => safeShareUrl(url: Uri.parse(article.url)),
          icon: CustomIcons.share,
          size: AppDimensions.iconSizeSmall,
          tooltip: localizations.articleCardLabelShare,
        ),
      ],
      title: article.title,
      titleUrl: article.url,
      description: summaryOrPlaceholder,
      metadata: [
        authorOrPlaceholder,
        AppDateFormat.dateTime.format(article.publishedAt),
      ],
    );
  }
}
