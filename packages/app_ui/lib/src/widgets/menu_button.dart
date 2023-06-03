import 'package:flutter/material.dart';

import 'widgets.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
    required this.menuItems,
  });

  final List<MenuItem> menuItems;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: (value) => menuItems[value].onTap(),
      itemBuilder: (_) => <PopupMenuEntry<int>>[
        ...List.generate(
          menuItems.length,
          (index) => PopupMenuItem<int>(
            value: index,
            child: menuItems[index],
          ),
        ),
      ],
    );
  }
}
