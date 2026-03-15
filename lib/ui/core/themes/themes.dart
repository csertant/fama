import 'package:flutter/material.dart';
import 'colors.dart';

var _baseTextStyle = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  fontStyle: FontStyle.normal,
  fontFamily: 'Times New Roman',
);

abstract final class AppTheme {
  static final _textTheme = TextTheme(
    /// Currently unused.
    displayLarge: _baseTextStyle.copyWith(fontSize: 60, color: Colors.red),

    /// Used for the greetings on Profile screen.
    /// Similar styles:
    /// - displaySmall (smaller)
    displayMedium: _baseTextStyle.copyWith(fontSize: 52),

    /// Used for the title in CustomScreen widgets
    /// and for the name on Profile screen.
    /// Similar styles:
    /// - displayMedium (larger)
    displaySmall: _baseTextStyle.copyWith(fontSize: 40),

    /// Currently unused.
    headlineLarge: _baseTextStyle.copyWith(fontSize: 60, color: Colors.red),

    /// Used for the title on CustomSection widgets.
    /// Similar styles:
    /// - titleMedium (bit smaller)
    /// - bodyMedium (smaller)
    headlineMedium: _baseTextStyle.copyWith(fontSize: 30),

    /// Currently unused.
    headlineSmall: _baseTextStyle.copyWith(fontSize: 60, color: Colors.red),

    /// Used for the text inside CustomSubsection widgets.
    /// Similar styles:
    /// - titleMedium (black)
    /// - bodyLarge (smaller)
    titleLarge: _baseTextStyle.copyWith(fontSize: 24),

    /// Used for the title in CustomSubsection widgets.
    /// Similar styles:
    /// - headlineMedium (larger)
    /// - titleLarge (blue)
    /// - bodyMedium (smaller)
    titleMedium: _baseTextStyle.copyWith(fontSize: 24),

    /// Currently unused.
    titleSmall: _baseTextStyle.copyWith(fontSize: 60, color: Colors.red),

    /// Used for texts.
    /// Similar styles:
    /// - titleLarge (larger)
    /// - bodyMedium (black)
    /// - labelLarge (underlined)
    bodyLarge: _baseTextStyle.copyWith(fontSize: 18),

    /// Used for texts.
    /// Similar styles:
    /// - headlineMedium (larger)
    /// - titleMedium (bit larger)
    /// - bodyLarge (blue)
    /// - labelMedium (underlined)
    bodyMedium: _baseTextStyle,

    /// Used for texts in CustomTextFormField widgets.
    /// Similar styles:
    /// - labelSmall (without dotted underline)
    bodySmall: _baseTextStyle.copyWith(fontSize: 14),

    /// Used for hyperlinked texts.
    /// Similar styles:
    /// - bodyLarge (without underline)
    /// - labelMedium (black)
    labelLarge: _baseTextStyle.copyWith(decoration: TextDecoration.underline),

    /// Used for hyperlinked texts.
    /// Similar styles:
    /// - bodyMedium (without underline)
    /// - labelLarge (blue)
    labelMedium: _baseTextStyle.copyWith(decoration: TextDecoration.underline),

    /// Used for hints in CustomTextFormField.
    /// Similar styles:
    /// - bodySmall (with underline)
    labelSmall: _baseTextStyle.copyWith(decoration: TextDecoration.underline),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: AppColors.lightColorScheme,
    textTheme: _textTheme,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: AppColors.darkColorScheme,
    textTheme: _textTheme,
  );
}
