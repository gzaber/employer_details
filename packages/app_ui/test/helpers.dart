import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpTest(
      {required WidgetBuilder builder,
      NavigatorObserver? navigatorObserver}) async {
    return pumpWidget(
      MaterialApp(
        navigatorObservers:
            navigatorObserver != null ? [navigatorObserver] : [],
        home: Scaffold(
          body: Builder(builder: builder),
        ),
      ),
    );
  }
}
