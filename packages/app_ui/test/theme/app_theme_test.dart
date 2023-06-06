import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme', () {
    test('returns ThemeData with correct brightness and color scheme', () {
      final themeData = AppTheme.themeData(
        brightness: Brightness.light,
        colorScheme: Colors.indigo,
      );

      expect(
        (themeData.brightness, themeData.colorScheme),
        equals(
          (
            Brightness.light,
            ColorScheme.fromSeed(seedColor: Colors.indigo),
          ),
        ),
      );
    });
  });
}
