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
    displayLarge: _baseTextStyle.copyWith(fontSize: 48),
    displayMedium: _baseTextStyle.copyWith(fontSize: 44),
    displaySmall: _baseTextStyle.copyWith(fontSize: 40),

    headlineLarge: _baseTextStyle.copyWith(fontSize: 36),
    headlineMedium: _baseTextStyle.copyWith(fontSize: 33),
    headlineSmall: _baseTextStyle.copyWith(fontSize: 30),

    titleLarge: _baseTextStyle.copyWith(fontSize: 24),
    titleMedium: _baseTextStyle.copyWith(fontSize: 22),
    titleSmall: _baseTextStyle.copyWith(fontSize: 20),

    bodyLarge: _baseTextStyle.copyWith(fontSize: 18),
    bodyMedium: _baseTextStyle,
    bodySmall: _baseTextStyle.copyWith(fontSize: 14),

    labelLarge: _baseTextStyle.copyWith(fontSize: 16),
    labelMedium: _baseTextStyle.copyWith(fontSize: 14),
    labelSmall: _baseTextStyle.copyWith(fontSize: 12),
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

  static final AppBarTheme _appBarTheme = AppBarTheme(
    elevation: 2,
    centerTitle: true,
    titleTextStyle: _textTheme.titleLarge,
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: AppColors.lightColorScheme,
    textTheme: _textTheme,
    navigationBarTheme: _lightNavigationBarTheme,
    appBarTheme: _appBarTheme,
    fontFamily: 'Times New Roman',
    fontFamilyFallback: const ['Times', 'serif'],
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: AppColors.darkColorScheme,
    textTheme: _textTheme,
    navigationBarTheme: _darkNavigationBarTheme,
    appBarTheme: _appBarTheme,
    fontFamily: 'Times New Roman',
    fontFamilyFallback: const ['Times', 'serif'],
  );
}
