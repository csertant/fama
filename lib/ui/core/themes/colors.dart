import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color black = Color(0xFF0A0A0A);
  static const Color darkGrey = Color(0xFF323232);
  static const Color lightGrey = Color(0xFFC8C8C8);
  static const Color white = Color(0xFFF5F5F5);

  static const Color red = Color(0xFFFF0000);

  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: black,
    onPrimary: white,
    secondary: darkGrey,
    onSecondary: lightGrey,
    surface: white,
    onSurface: lightGrey,
    error: red,
    onError: white,
    outline: black,
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: white,
    onPrimary: black,
    secondary: lightGrey,
    onSecondary: darkGrey,
    surface: black,
    onSurface: darkGrey,
    error: red,
    onError: white,
    outline: white,
  );
}
