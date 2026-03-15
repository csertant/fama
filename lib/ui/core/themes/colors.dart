import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color black = Color.fromARGB(255, 10, 10, 10);
  static const Color darkGrey = Color.fromARGB(255, 50, 50, 50);
  static const Color lightGrey = Color.fromARGB(255, 200, 200, 200);
  static const Color white = Color.fromARGB(255, 245, 245, 245);

  static const Color red = Color.fromARGB(255, 255, 0, 0);

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
