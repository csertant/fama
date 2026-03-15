import 'package:flutter/material.dart';

abstract final class AppDimensions {
  const AppDimensions();

  /// Get dimensions definition based on screen size
  factory AppDimensions.of(BuildContext context) =>
      switch (MediaQuery.sizeOf(context).width) {
        > 600 && < 840 => desktop,
        _ => mobile,
      };

  static const paddingLarge = 32.0;
  static const paddingMedium = 16.0;
  static const paddingSmall = 8.0;

  double get paddingScreenHorizontal;
  double get paddingScreenVertical;

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
}

/// Desktop/Web dimensions
final class _AppDimensionsDesktop extends AppDimensions {
  const _AppDimensionsDesktop();

  @override
  double get paddingScreenHorizontal => AppDimensions.paddingLarge * 3;

  @override
  double get paddingScreenVertical => AppDimensions.paddingMedium * 3;
}
