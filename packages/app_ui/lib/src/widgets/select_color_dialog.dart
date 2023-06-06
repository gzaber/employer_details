import 'package:flutter/material.dart';

class SelectColorDialog extends StatelessWidget {
  const SelectColorDialog({
    Key? key,
    required this.title,
    required this.declineButtonText,
    required this.colors,
  }) : super(key: key);

  final String title;
  final String declineButtonText;
  final List<Color> colors;

  static Future<Color?> show(
    BuildContext context, {
    required String title,
    required String declineButtonText,
    required List<Color> colors,
  }) {
    return showDialog<Color>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (_) => SelectColorDialog(
        title: title,
        declineButtonText: declineButtonText,
        colors: colors,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      title: Text(title),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: GridView.builder(
          itemCount: colors.length,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (_, index) {
            return InkWell(
              onTap: () {
                Navigator.pop(context, colors[index]);
              },
              child: Container(
                key: Key('selectColorDialogColorBoxKey$index'),
                color: colors[index],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          key: const Key('selectColorDialogDeclineButtonKey'),
          child: Text(declineButtonText),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
      ],
    );
  }
}
