import 'package:flutter/material.dart';

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

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final IconData icon;
  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        const SizedBox(width: 20),
        Text(text),
      ],
    );
  }
}
