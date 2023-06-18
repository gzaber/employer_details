import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ExportDetailsDialog extends StatelessWidget {
  ExportDetailsDialog({
    Key? key,
    required this.title,
    required this.selectPathText,
    required this.pathLabel,
    required this.fileNameLabel,
    required this.declineButtonText,
    required this.approveButtonText,
    FilePicker? filePicker,
    DateTime? dateTime,
  })  : _filePicker = filePicker ?? FilePicker.platform,
        _dateTime = dateTime ?? DateTime.now(),
        super(key: key);

  final String title;
  final String selectPathText;
  final String pathLabel;
  final String fileNameLabel;
  final String declineButtonText;
  final String approveButtonText;
  final FilePicker _filePicker;
  final DateTime _dateTime;

  static Future<(String, String)?> show(
    BuildContext context, {
    required String title,
    required String selectPathText,
    required String pathLabel,
    required String fileNameLabel,
    required String declineButtonText,
    required String approveButtonText,
  }) {
    return showDialog<(String, String)>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (_) => ExportDetailsDialog(
        title: title,
        selectPathText: selectPathText,
        pathLabel: pathLabel,
        fileNameLabel: fileNameLabel,
        declineButtonText: declineButtonText,
        approveButtonText: approveButtonText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pathController = TextEditingController();
    final fileNameController = TextEditingController();

    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(selectPathText),
                  IconButton(
                    icon: const Icon(Icons.folder_open),
                    onPressed: () async {
                      final result = await _filePicker.getDirectoryPath();
                      pathController.text = result ?? '';
                      fileNameController.text =
                          'details_${_dateTime.toIso8601String()}';
                    },
                  ),
                ],
              ),
              TextField(
                key: const Key('exportDetailsDialogPathTextFieldKey'),
                controller: pathController,
                enabled: false,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: pathLabel,
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                key: const Key('exportDetailsDialogFileNameTextFieldKey'),
                controller: fileNameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: fileNameLabel,
                ),
              ),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          key: const Key('exportDetailsDialogDeclineButtonKey'),
          child: Text(declineButtonText),
          onPressed: () => Navigator.pop(context, null),
        ),
        TextButton(
          key: const Key('exportDetailsDialogApproveButtonKey'),
          child: Text(approveButtonText),
          onPressed: () => Navigator.pop(
            context,
            (pathController.text, fileNameController.text),
          ),
        ),
      ],
    );
  }
}
