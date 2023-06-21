import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppColors', () {
    test('retrieves a value with a key', () {
      expect(AppColors.colors[Colors.pink.value], equals('pink'));
    });
  });
}
