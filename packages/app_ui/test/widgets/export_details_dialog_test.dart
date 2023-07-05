import 'package:app_ui/src/widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../helpers.dart';

class MockFilePicker extends Mock implements FilePicker {}

class MockDateTime extends Mock implements DateTime {}

void main() {
  group('ExportDetailsDialog', () {
    const date = '2023-06-17';
    const path = 'path/example';
    late MockNavigator mockNavigator;
    late FilePicker mockFilePicker;
    late DateTime mockDateTime;

    setUp(() {
      mockNavigator = MockNavigator();
      mockFilePicker = MockFilePicker();
      mockDateTime = MockDateTime();

      when(() => mockFilePicker.getDirectoryPath())
          .thenAnswer((_) async => path);

      when(() => mockDateTime.toIso8601String()).thenReturn(date);
    });

    buildExportDetailsDialog() => ExportDetailsDialog(
          title: 'title',
          selectPathText: 'selectPathText',
          pathLabel: 'pathLabel',
          fileNameLabel: 'fileNameLabel',
          declineButtonText: 'declineButtonText',
          approveButtonText: 'approveButtonText',
          filePicker: mockFilePicker,
          dateTime: mockDateTime,
        );

    testWidgets('show method shows dialog', (tester) async {
      await tester.pumpTest(
        builder: (context) => IconButton(
          onPressed: () => ExportDetailsDialog.show(
            context,
            title: 'title',
            selectPathText: 'selectPathText',
            pathLabel: 'pathLabel',
            fileNameLabel: 'fileNameLabel',
            declineButtonText: 'declineButtonText',
            approveButtonText: 'approveButtonText',
          ),
          icon: const Icon(Icons.import_export),
        ),
      );

      await tester.tap(find.byIcon(Icons.import_export));
      await tester.pumpAndSettle();

      expect(find.byType(ExportDetailsDialog), findsOneWidget);
    });

    testWidgets('selects path using FilePicker', (tester) async {
      await tester.pumpTest(builder: (_) => buildExportDetailsDialog());
      await tester.tap(find.byIcon(Icons.folder_open));

      final pathTextField = tester.widget<TextField>(
          find.byKey(const Key('exportDetailsDialogPathTextFieldKey')));

      expect(pathTextField.controller?.text, equals(path));
    });

    testWidgets('generates file name for export', (tester) async {
      await tester.pumpTest(builder: (_) => buildExportDetailsDialog());
      await tester.tap(find.byIcon(Icons.folder_open));

      final pathTextField = tester.widget<TextField>(
          find.byKey(const Key('exportDetailsDialogFileNameTextFieldKey')));

      expect(pathTextField.controller?.text, equals('details_$date'));
    });

    testWidgets('pops with path and file name when approve button is tapped',
        (tester) async {
      await tester.pumpTest(builder: (_) {
        return MockNavigatorProvider(
          navigator: mockNavigator,
          child: buildExportDetailsDialog(),
        );
      });
      await tester.tap(find.byIcon(Icons.folder_open));
      await tester
          .tap(find.byKey(const Key('exportDetailsDialogApproveButtonKey')));

      verify(
        () => mockNavigator.pop<(String, String)>((path, 'details_$date')),
      ).called(1);
    });

    testWidgets('pops with null when decline button is tapped', (tester) async {
      await tester.pumpTest(builder: (_) {
        return MockNavigatorProvider(
          navigator: mockNavigator,
          child: buildExportDetailsDialog(),
        );
      });
      await tester
          .tap(find.byKey(const Key('exportDetailsDialogDeclineButtonKey')));

      verify(() => mockNavigator.pop(null)).called(1);
    });
  });
}
