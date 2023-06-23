import 'package:app_ui/src/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  group('CustomSnackBar', () {
    testWidgets('show method shows SnackBar', (tester) async {
      await tester.pumpTest(
        builder: (context) => FloatingActionButton(onPressed: () {
          CustomSnackBar.show(
            context: context,
            text: 'text',
            backgroundColor: Colors.red,
          );
        }),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
