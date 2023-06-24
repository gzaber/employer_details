import 'package:flutter/material.dart';

class HintCard extends StatelessWidget {
  const HintCard({
    super.key,
    required this.title,
    required this.upperText,
    required this.lowerText,
    required this.hintMenuVisualisations,
  });

  final String title;
  final String upperText;
  final String lowerText;
  final List<HintMenuVisualisation> hintMenuVisualisations;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(upperText),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...hintMenuVisualisations,
                    ],
                  ),
                ),
                Text(lowerText),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HintMenuVisualisation extends StatelessWidget {
  const HintMenuVisualisation({
    super.key,
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
