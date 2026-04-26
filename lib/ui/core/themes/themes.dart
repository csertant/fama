import 'package:flutter/material.dart';
import 'colors.dart';
import 'dimensions.dart';

var _baseTextStyle = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  fontStyle: FontStyle.normal,
  fontFamily: 'Times New Roman',
  fontFamilyFallback: ['Times', 'serif'],
);

abstract final class AppTheme {
  static final _textTheme = TextTheme(
    // Currently unused
    displayLarge: _baseTextStyle.copyWith(color: Colors.deepPurple),
    displayMedium: _baseTextStyle.copyWith(color: Colors.deepPurple),
    displaySmall: _baseTextStyle.copyWith(color: Colors.deepPurple),

    //Currently unused
    headlineLarge: _baseTextStyle.copyWith(color: Colors.deepPurple),
    headlineMedium: _baseTextStyle.copyWith(color: Colors.deepPurple),
    headlineSmall: _baseTextStyle.copyWith(color: Colors.deepPurple),

    titleLarge: _baseTextStyle.copyWith(fontSize: 24),
    titleMedium: _baseTextStyle.copyWith(fontSize: 22),
    titleSmall: _baseTextStyle.copyWith(fontSize: 20),

    bodyLarge: _baseTextStyle.copyWith(fontSize: 18),
    bodyMedium: _baseTextStyle,
    bodySmall: _baseTextStyle.copyWith(fontSize: 14),

    labelLarge: _baseTextStyle.copyWith(
      fontSize: 16,
      fontStyle: FontStyle.italic,
    ),
    labelMedium: _baseTextStyle.copyWith(
      fontSize: 14,
      fontStyle: FontStyle.italic,
    ),
    labelSmall: _baseTextStyle.copyWith(
      fontSize: 12,
      fontStyle: FontStyle.italic,
    ),
  );

  static final _lightNavigationBarTheme = NavigationBarThemeData(
    height: AppDimensions.navigationBarHeight,
    backgroundColor: AppColors.lightColorScheme.surface,
    indicatorColor: AppColors.lightColorScheme.primary,
    iconTheme: WidgetStateProperty.resolveWith((states) {
      final selected = states.contains(WidgetState.selected);
      return IconThemeData(
        color: selected
            ? AppColors.lightColorScheme.primary
            : AppColors.lightColorScheme.surface,
      );
    }),
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      final selected = states.contains(WidgetState.selected);
      return _baseTextStyle.copyWith(
        fontSize: 12,
        color: selected
            ? AppColors.lightColorScheme.onSecondary
            : AppColors.lightColorScheme.onPrimary,
      );
    }),
    labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
  );

  static final _darkNavigationBarTheme = NavigationBarThemeData(
    height: AppDimensions.navigationBarHeight,
    backgroundColor: AppColors.darkColorScheme.surface,
    indicatorColor: AppColors.darkColorScheme.primary,
    iconTheme: WidgetStateProperty.resolveWith((states) {
      final selected = states.contains(WidgetState.selected);
      return IconThemeData(
        color: selected
            ? AppColors.darkColorScheme.primary
            : AppColors.darkColorScheme.surface,
      );
    }),
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      final selected = states.contains(WidgetState.selected);
      return _baseTextStyle.copyWith(
        fontSize: 12,
        color: selected
            ? AppColors.darkColorScheme.onSecondary
            : AppColors.darkColorScheme.onPrimary,
      );
    }),
    labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
  );

  static const AppBarTheme _appBarTheme = AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
  );

  static const _noElevationButtonStyle = ButtonStyle(
    elevation: WidgetStatePropertyAll<double>(0),
    shadowColor: WidgetStatePropertyAll<Color>(Colors.transparent),
    surfaceTintColor: WidgetStatePropertyAll<Color>(Colors.transparent),
  );

  static final _lightProgressIndicatorTheme = ProgressIndicatorThemeData(
    color: AppColors.lightColorScheme.outline,
    //There is likely a bug in Flutter where though this param is deprecated
    //it still evaluates to true and causes the widget to use the old style
    //We need to revisit this once material3 designs are fixed
    // Tracked issue: https://github.com/flutter/flutter/issues/168813
    // ignore: deprecated_member_use
    year2023: false,
  );

  static final _darkProgressIndicatorTheme = ProgressIndicatorThemeData(
    color: AppColors.darkColorScheme.outline,
    //There is likely a bug in Flutter where though this param is deprecated
    //it still evaluates to true and causes the widget to use the old style
    //We need to revisit this once material3 designs are fixed
    // Tracked issue: https://github.com/flutter/flutter/issues/168813
    // ignore: deprecated_member_use
    year2023: false,
  );

  static final _chipTheme = ChipThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    padding: const EdgeInsets.symmetric(
      horizontal: AppDimensions.paddingExtraSmall,
      vertical: AppDimensions.paddingSmall,
    ),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: AppColors.lightColorScheme,
    textTheme: _textTheme,
    navigationBarTheme: _lightNavigationBarTheme,
    appBarTheme: _appBarTheme,
    cardTheme: const CardThemeData(elevation: 0),
    progressIndicatorTheme: _lightProgressIndicatorTheme,
    chipTheme: _chipTheme,
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: _noElevationButtonStyle,
    ),
    filledButtonTheme: const FilledButtonThemeData(
      style: _noElevationButtonStyle,
    ),
    outlinedButtonTheme: const OutlinedButtonThemeData(
      style: _noElevationButtonStyle,
    ),
    textButtonTheme: const TextButtonThemeData(style: _noElevationButtonStyle),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      disabledElevation: 0,
    ),
    fontFamily: 'Times New Roman',
    fontFamilyFallback: const ['Times', 'serif'],
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: AppColors.darkColorScheme,
    textTheme: _textTheme,
    navigationBarTheme: _darkNavigationBarTheme,
    appBarTheme: _appBarTheme,
    cardTheme: const CardThemeData(elevation: 0),
    progressIndicatorTheme: _darkProgressIndicatorTheme,
    chipTheme: _chipTheme,
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: _noElevationButtonStyle,
    ),
    filledButtonTheme: const FilledButtonThemeData(
      style: _noElevationButtonStyle,
    ),
    outlinedButtonTheme: const OutlinedButtonThemeData(
      style: _noElevationButtonStyle,
    ),
    textButtonTheme: const TextButtonThemeData(style: _noElevationButtonStyle),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      disabledElevation: 0,
    ),
    fontFamily: 'Times New Roman',
    fontFamilyFallback: const ['Times', 'serif'],
  );
}
