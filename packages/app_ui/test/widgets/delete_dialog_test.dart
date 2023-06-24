import 'package:app_ui/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../helpers.dart';

void main() {
  group('DeleteDetailDialog', () {
    late MockNavigator mockNavigator;

    setUp(() {
      mockNavigator = MockNavigator();
    });

    buildDeleteDetailDialog() => const DeleteDialog(
          title: 'title',
          contentText: 'contentText',
          declineButtonText: 'declineButtonText',
          approveButtonText: 'approveButtonText',
        );

    testWidgets('show method shows dialog', (tester) async {
      await tester.pumpTest(
        builder: (context) => IconButton(
          onPressed: () => DeleteDialog.show(
            context,
            title: 'title',
            contentText: 'contentText',
            declineButtonText: 'declineButtonText',
            approveButtonText: 'approveButtonText',
          ),
          icon: const Icon(Icons.delete),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(find.byType(DeleteDialog), findsOneWidget);
    });

    testWidgets('pops with true when approve button is tapped', (tester) async {
      await tester.pumpTest(
        builder: (context) => MockNavigatorProvider(
          navigator: mockNavigator,
          child: buildDeleteDetailDialog(),
        ),
      );

      await tester.tap(find.byKey(const Key('deleteDialogApproveButtonKey')));

      verify(() => mockNavigator.pop<bool>(true)).called(1);
    });

    testWidgets('pops with false when decline button is tapped',
        (tester) async {
      await tester.pumpTest(
        builder: (context) => MockNavigatorProvider(
          navigator: mockNavigator,
          child: buildDeleteDetailDialog(),
        ),
      );

      await tester.tap(find.byKey(const Key('deleteDialogDeclineButtonKey')));

      verify(() => mockNavigator.pop<bool>(false)).called(1);
    });
  });
}
