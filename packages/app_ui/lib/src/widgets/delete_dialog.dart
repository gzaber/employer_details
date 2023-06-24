import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({
    Key? key,
    required this.title,
    required this.contentText,
    required this.declineButtonText,
    required this.approveButtonText,
  }) : super(key: key);

  final String title;
  final String contentText;
  final String declineButtonText;
  final String approveButtonText;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String contentText,
    required String declineButtonText,
    required String approveButtonText,
  }) {
    return showDialog<bool>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (_) => DeleteDialog(
        title: title,
        contentText: contentText,
        declineButtonText: declineButtonText,
        approveButtonText: approveButtonText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(contentText),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          key: const Key('deleteDialogDeclineButtonKey'),
          child: Text(declineButtonText),
          onPressed: () => Navigator.pop(context, false),
        ),
        TextButton(
          key: const Key('deleteDialogApproveButtonKey'),
          child: Text(approveButtonText),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
