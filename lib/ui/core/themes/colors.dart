import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color black = Color(0xFF0A0A0A);
  static const Color darkGrey = Color(0xFF323232);
  static const Color lightGrey = Color(0xFFC8C8C8);
  static const Color white = Color(0xFFF5F5F5);

  static const Color red = Color(0xFFFF0000);

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
