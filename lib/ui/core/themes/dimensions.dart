import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

abstract final class AppDimensions {
  const AppDimensions();

  /// Get dimensions definition based on screen size
  factory AppDimensions.of(BuildContext context) =>
      switch (MediaQuery.sizeOf(context).width) {
        < mobileMaxWidth => mobile,
        < tabletMaxWidth => tablet,
        _ => desktop,
      };

  static const tabletMaxWidth = 840.0;
  static const mobileMaxWidth = 600.0;

  static const appBarHeight = 56.0;
  static const navigationBarHeight = 72.0;

  static const paddingLarge = 32.0;
  static const paddingMedium = 16.0;
  static const paddingSmall = 8.0;
  static const paddingExtraSmall = 4.0;

  static const borderRadiusMedium = 18.0;

  static const iconSizeLarge = 28.0;
  static const iconSizeMedium = 24.0;
  static const iconSizeSmall = 20.0;

  static const badgeSizeLarge = 4.0;
  static const badgeSizeSmall = 2.0;
  static const badgeOffset = Offset(8, -8);

  static const leadingImageWidthRatio = 0.25;
  static const leadingImageMinWidth = 128.0;
  static const leadingImageMaxWidth = 256.0;

  static const headingImageAspectRatio = 16 / 9;

  static const sourceImageSize = 64.0;

  double get paddingScreenHorizontal;
  double get paddingScreenVertical;

  double get iconSizeDefault;

  ArticleCardLayout get articleCardLayout;

  EdgeInsets get edgeInsetsScreenHorizontal =>
      EdgeInsets.symmetric(horizontal: paddingScreenHorizontal);

  EdgeInsets get edgeInsetsScreenAll => EdgeInsets.symmetric(
    horizontal: paddingScreenHorizontal,
    vertical: paddingScreenVertical,
  );

  static const AppDimensions mobile = _AppDimensionsMobile();
  static const AppDimensions tablet = _AppDimensionsTablet();
  static const AppDimensions desktop = _AppDimensionsDesktop();
}

/// Mobile dimensions
final class _AppDimensionsMobile extends AppDimensions {
  const _AppDimensionsMobile();

  @override
  double get paddingScreenHorizontal => AppDimensions.paddingLarge;

  @override
  double get paddingScreenVertical => AppDimensions.paddingMedium;

  @override
  double get iconSizeDefault => AppDimensions.iconSizeMedium;

  @override
  ArticleCardLayout get articleCardLayout => ArticleCardLayout.headingImage;
}

/// Tablet dimensions
final class _AppDimensionsTablet extends AppDimensions {
  const _AppDimensionsTablet();

  @override
  double get paddingScreenHorizontal => AppDimensions.paddingLarge * 2;

  @override
  double get paddingScreenVertical => AppDimensions.paddingMedium * 2;

  @override
  double get iconSizeDefault => AppDimensions.iconSizeLarge;

  @override
  ArticleCardLayout get articleCardLayout => ArticleCardLayout.leadingImage;
}

/// PC/Web dimensions
final class _AppDimensionsDesktop extends AppDimensions {
  const _AppDimensionsDesktop();

  @override
  double get paddingScreenHorizontal => AppDimensions.paddingLarge * 3;

  @override
  double get paddingScreenVertical => AppDimensions.paddingMedium * 3;

  @override
  double get iconSizeDefault => AppDimensions.iconSizeLarge;

  @override
  ArticleCardLayout get articleCardLayout => ArticleCardLayout.leadingImage;
}
