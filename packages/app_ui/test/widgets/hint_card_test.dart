import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  group('HintCard', () {
    const hintCard = HintCard(
      title: 'title',
      upperText: 'upperText',
      lowerText: 'lowerText',
      hintMenuVisualisations: [
        HintMenuVisualisation(icon: Icons.home, text: 'home'),
        HintMenuVisualisation(icon: Icons.delete, text: 'delete'),
      ],
    );

    testWidgets('renders correct title', (tester) async {
      await tester.pumpTest(builder: (_) => hintCard);

      expect(find.text('title'), findsOneWidget);
    });

    testWidgets('renders correct upper text', (tester) async {
      await tester.pumpTest(builder: (_) => hintCard);

      expect(find.text('upperText'), findsOneWidget);
    });

    testWidgets('renders correct lower text', (tester) async {
      await tester.pumpTest(builder: (_) => hintCard);

      expect(find.text('lowerText'), findsOneWidget);
    });

    testWidgets('renders 2 menu visualisation rows', (tester) async {
      await tester.pumpTest(builder: (_) => hintCard);

      expect(find.byType(HintMenuVisualisation), findsNWidgets(2));
    });

    testWidgets('renders correct icons and texts for menu visualisation rows',
        (tester) async {
      await tester.pumpTest(builder: (_) => hintCard);

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
      expect(find.text('home'), findsOneWidget);
      expect(find.text('delete'), findsOneWidget);
    });
  });
}
