import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImportDetailsDialog extends StatelessWidget {
  ImportDetailsDialog({
    Key? key,
    required this.title,
    required this.selectFileText,
    required this.fileLabel,
    required this.declineButtonText,
    required this.approveButtonText,
    FilePicker? filePicker,
  })  : _filePicker = filePicker ?? FilePicker.platform,
        super(key: key);

  final String title;
  final String selectFileText;
  final String fileLabel;
  final String declineButtonText;
  final String approveButtonText;
  final FilePicker _filePicker;

  static Future<String?> show(
    BuildContext context, {
    required String title,
    required String selectFileText,
    required String fileLabel,
    required String declineButtonText,
    required String approveButtonText,
  }) {
    return showDialog<String>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (_) => ImportDetailsDialog(
        title: title,
        selectFileText: selectFileText,
        fileLabel: fileLabel,
        declineButtonText: declineButtonText,
        approveButtonText: approveButtonText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filePathController = TextEditingController();

    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(selectFileText),
              IconButton(
                icon: const Icon(Icons.file_open),
                onPressed: () async {
                  final result = await _filePicker.pickFiles();
                  filePathController.text = result?.files.single.path ?? 'lol';
                },
              ),
            ],
          ),
          TextField(
            key: const Key('importDetailsDialogFilePathTextFieldKey'),
            controller: filePathController,
            enabled: false,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: fileLabel,
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          key: const Key('importDetailsDialogDeclineButtonKey'),
          child: Text(declineButtonText),
          onPressed: () => Navigator.pop(context, null),
        ),
        TextButton(
          key: const Key('importDetailsDialogApproveButtonKey'),
          child: Text(approveButtonText),
          onPressed: () => Navigator.pop(context, filePathController.text),
        ),
      ],
    );
  }
}
