import 'package:flutter/material.dart';

class DeleteDetailDialog extends StatelessWidget {
  const DeleteDetailDialog({
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
      builder: (_) => DeleteDetailDialog(
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
          key: const Key('deleteDetailDialogDeclineButtonKey'),
          child: Text(declineButtonText),
          onPressed: () => Navigator.pop(context, false),
        ),
        TextButton(
          key: const Key('deleteDetailDialogApproveButtonKey'),
          child: Text(approveButtonText),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
