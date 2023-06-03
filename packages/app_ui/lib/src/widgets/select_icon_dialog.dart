import 'package:flutter/material.dart';

class SelectIconDialog extends StatelessWidget {
  const SelectIconDialog({
    Key? key,
    required this.title,
    required this.declineButtonText,
    required this.icons,
  }) : super(key: key);

  final String title;
  final String declineButtonText;
  final List<IconData> icons;

  static Future<IconData?> show(
    BuildContext context, {
    required String title,
    required String declineButtonText,
    required List<IconData> icons,
  }) {
    return showDialog<IconData>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (_) => SelectIconDialog(
        title: title,
        declineButtonText: declineButtonText,
        icons: icons,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      title: Text(title),
      content: GridView.builder(
        itemCount: icons.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemBuilder: (_, index) {
          return InkWell(
            onTap: () {
              Navigator.pop(context, icons[index]);
            },
            child: CircleAvatar(
              child: Icon(icons[index]),
            ),
          );
        },
      ),
      actions: [
        TextButton(
          child: Text(declineButtonText),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
