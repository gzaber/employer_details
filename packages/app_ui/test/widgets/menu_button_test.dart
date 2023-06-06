import 'package:app_ui/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  group('MenuButton', () {
    final menuButton = MenuButton(menuItems: [
      MenuItem(icon: Icons.edit, text: 'edit', onTap: () {}),
      MenuItem(icon: Icons.delete, text: 'delete', onTap: () {}),
    ]);

    testWidgets('renders default icon', (tester) async {
      await tester.pumpTest(
        builder: (_) => menuButton,
      );

      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('renders menu items when button is tapped', (tester) async {
      await tester.pumpTest(
        builder: (_) => menuButton,
      );

      await tester.tap(find.byType(MenuButton));
      await tester.pumpAndSettle();

      expect(find.byType(MenuItem), findsNWidgets(2));
    });

    testWidgets('renders proper icons and texts of menu items', (tester) async {
      await tester.pumpTest(
        builder: (_) => menuButton,
      );

      await tester.tap(find.byType(MenuButton));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.text('edit'), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
      expect(find.text('delete'), findsOneWidget);
    });

    testWidgets('menu item can be tapped', (tester) async {
      await tester.pumpTest(
        builder: (_) => menuButton,
      );

      await tester.tap(find.byType(MenuButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('edit'));
    });
  });
}
