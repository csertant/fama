import 'package:flutter/material.dart';

abstract final class AppDimensions {
  const AppDimensions();

  /// Get dimensions definition based on screen size
  factory AppDimensions.of(BuildContext context) =>
      switch (MediaQuery.sizeOf(context).width) {
        > 600 && < 840 => desktop,
        _ => mobile,
      };

  static const navigationBarHeight = 72.0;

  static const paddingLarge = 32.0;
  static const paddingMedium = 16.0;
  static const paddingSmall = 8.0;

  static const iconSizeLarge = 32.0;
  static const iconSizeMedium = 24.0;
  static const iconSizeSmall = 16.0;

  double get paddingScreenHorizontal;
  double get paddingScreenVertical;

  double get iconSizeDefault;

  EdgeInsets get edgeInsetsScreenHorizontal =>
      EdgeInsets.symmetric(horizontal: paddingScreenHorizontal);

  EdgeInsets get edgeInsetsScreenAll => EdgeInsets.symmetric(
    horizontal: paddingScreenHorizontal,
    vertical: paddingScreenVertical,
  );

  static const AppDimensions desktop = _AppDimensionsDesktop();
  static const AppDimensions mobile = _AppDimensionsMobile();
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
}

/// Desktop/Web dimensions
final class _AppDimensionsDesktop extends AppDimensions {
  const _AppDimensionsDesktop();

  @override
  double get paddingScreenHorizontal => AppDimensions.paddingLarge * 3;

  @override
  double get paddingScreenVertical => AppDimensions.paddingMedium * 3;

  @override
  double get iconSizeDefault => AppDimensions.iconSizeLarge;
}
