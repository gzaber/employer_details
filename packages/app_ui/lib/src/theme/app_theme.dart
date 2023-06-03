import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData themeData({
    required Brightness brightness,
    required Color colorScheme,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorSchemeSeed: colorScheme,
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }
}
