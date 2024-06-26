import 'package:flutter/material.dart';

class ThemeManager {
  static const ThemeMode themeMode = ThemeMode.system;

  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromRGBO(206,193,141, 1),
      brightness: Brightness.light,
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromRGBO(206,193,141, 1),
      brightness: Brightness.dark,
    ),
  );
}