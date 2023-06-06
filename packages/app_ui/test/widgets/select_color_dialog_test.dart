import 'package:app_ui/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../helpers.dart';

void main() {
  group('SelectColorDialog', () {
    late MockNavigator mockNavigator;

    setUp(() {
      mockNavigator = MockNavigator();
    });

    buildSelectColorDialog() => const SelectColorDialog(
          title: 'Title',
          declineButtonText: 'Decline',
          colors: [Colors.red, Colors.green, Colors.blue],
        );

    testWidgets('show method shows dialog', (tester) async {
      await tester.pumpTest(
        builder: (context) => IconButton(
          onPressed: () => SelectColorDialog.show(
            context,
            title: 'Title',
            declineButtonText: 'Decline',
            colors: [Colors.red, Colors.green, Colors.blue],
          ),
          icon: const Icon(Icons.edit),
        ),
      );

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      expect(find.byType(SelectColorDialog), findsOneWidget);
    });

    testWidgets('pops with color when color box is tapped', (tester) async {
      await tester.pumpTest(builder: (context) {
        return MockNavigatorProvider(
          navigator: mockNavigator,
          child: buildSelectColorDialog(),
        );
      });

      await tester.tap(find.byKey(const Key('selectColorDialogColorBoxKey0')));

      verify(
        () => mockNavigator.pop<Color>(Colors.red),
      ).called(1);
    });

    testWidgets('pops with null when decline button is tapped', (tester) async {
      await tester.pumpTest(builder: (context) {
        return MockNavigatorProvider(
          navigator: mockNavigator,
          child: buildSelectColorDialog(),
        );
      });

      await tester
          .tap(find.byKey(const Key('selectColorDialogDeclineButtonKey')));

      verify(
        () => mockNavigator.pop(null),
      ).called(1);
    });
  });
}
