import 'package:app_ui/src/widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../helpers.dart';

class MockFilePicker extends Mock implements FilePicker {}

void main() {
  group('ImportDetailsDialog', () {
    const filePath = 'path/fileName';
    final platformFile = PlatformFile(
      name: 'fileName',
      size: 0,
      path: filePath,
    );
    late MockNavigator mockNavigator;
    late FilePicker mockFilerPicker;

    setUp(() {
      mockNavigator = MockNavigator();
      mockFilerPicker = MockFilePicker();

      when(() => mockFilerPicker.pickFiles())
          .thenAnswer((_) async => FilePickerResult([platformFile]));
    });

    buildImportDetailsDialog() => ImportDetailsDialog(
          title: 'title',
          selectFileText: 'selectFileText',
          fileLabel: 'fileLabel',
          declineButtonText: 'declineButtonText',
          approveButtonText: 'approveButtonText',
          filePicker: mockFilerPicker,
        );

    testWidgets('show method shows dialog', (tester) async {
      await tester.pumpTest(
        builder: (context) => IconButton(
          onPressed: () => ImportDetailsDialog.show(
            context,
            title: 'title',
            selectFileText: 'selectFileText',
            fileLabel: 'fileLabel',
            declineButtonText: 'declineButtonText',
            approveButtonText: 'approveButtonText',
          ),
          icon: const Icon(Icons.import_export),
        ),
      );

      await tester.tap(find.byIcon(Icons.import_export));
      await tester.pumpAndSettle();

      expect(find.byType(ImportDetailsDialog), findsOneWidget);
    });

    testWidgets('selects file path using FilePicker', (tester) async {
      await tester.pumpTest(builder: (_) => buildImportDetailsDialog());
      await tester.tap(find.byIcon(Icons.file_open));

      final filePathTextField = tester.widget<TextField>(
          find.byKey(const Key('importDetailsDialogFilePathTextFieldKey')));

      expect(filePathTextField.controller?.text, equals(filePath));
    });

    testWidgets('pops with file path when approve button is tapped',
        (tester) async {
      await tester.pumpTest(builder: (_) {
        return MockNavigatorProvider(
          navigator: mockNavigator,
          child: buildImportDetailsDialog(),
        );
      });
      await tester.tap(find.byIcon(Icons.file_open));
      await tester
          .tap(find.byKey(const Key('importDetailsDialogApproveButtonKey')));

      verify(
        () => mockNavigator.pop<String>(filePath),
      ).called(1);
    });

    testWidgets('pops with null when decline button is tapped', (tester) async {
      await tester.pumpTest(builder: (_) {
        return MockNavigatorProvider(
          navigator: mockNavigator,
          child: buildImportDetailsDialog(),
        );
      });
      await tester
          .tap(find.byKey(const Key('importDetailsDialogDeclineButtonKey')));

      verify(() => mockNavigator.pop(null)).called(1);
    });
  });
}
