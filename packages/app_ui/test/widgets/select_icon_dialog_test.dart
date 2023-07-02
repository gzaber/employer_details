import 'package:app_ui/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../helpers.dart';

void main() {
  group('SelectIconDialog', () {
    late MockNavigator mockNavigator;

    setUp(() {
      mockNavigator = MockNavigator();
    });

    buildSelectIconDialog() => const SelectIconDialog(
          title: 'Title',
          declineButtonText: 'Decline',
          icons: [Icons.home, Icons.edit, Icons.delete],
        );

    testWidgets('show method shows dialog', (tester) async {
      await tester.pumpTest(
        builder: (context) => IconButton(
          onPressed: () => SelectIconDialog.show(
            context,
            title: 'Title',
            declineButtonText: 'Decline',
            icons: [Icons.home, Icons.edit, Icons.delete],
          ),
          icon: const Icon(Icons.edit),
        ),
      );

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      expect(find.byType(SelectIconDialog), findsOneWidget);
    });

    testWidgets('pops with icon data when icon is tapped', (tester) async {
      await tester.pumpTest(builder: (context) {
        return MockNavigatorProvider(
          navigator: mockNavigator,
          child: buildSelectIconDialog(),
        );
      });

      await tester.tap(find.byKey(const Key('selectIconDialogIconKey0')));

      verify(
        () => mockNavigator.pop<IconData>(Icons.home),
      ).called(1);
    });

    testWidgets('pops with null when decline button is tapped', (tester) async {
      await tester.pumpTest(builder: (context) {
        return MockNavigatorProvider(
          navigator: mockNavigator,
          child: buildSelectIconDialog(),
        );
      });

      await tester
          .tap(find.byKey(const Key('selectIconDialogDeclineButtonKey')));

      verify(
        () => mockNavigator.pop(null),
      ).called(1);
    });
  });
}
