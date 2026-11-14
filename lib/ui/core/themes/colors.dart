import 'package:material_ui/material_ui.dart';

abstract final class AppColors {
  static const black = Color(0xFF0A0A0A);
  static const darkGrey = Color(0xFF323232);
  static const lightGrey = Color(0xFFC8C8C8);
  static const white = Color(0xFFF5F5F5);

  static const red = Color(0xFFFF0000);
  static const green = Color(0xFF4CAF50);

  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: lightGrey,
    onPrimary: darkGrey,
    secondary: white,
    onSecondary: black,
    surface: white,
    onSurface: black,
    error: red,
    onError: white,
    outline: black,
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: darkGrey,
    onPrimary: lightGrey,
    secondary: black,
    onSecondary: white,
    surface: black,
    onSurface: white,
    error: red,
    onError: black,
    outline: white,
  );
}
