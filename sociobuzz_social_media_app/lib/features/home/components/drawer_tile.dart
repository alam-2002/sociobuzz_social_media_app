import 'package:flutter/material.dart';
import 'package:sociobuzz_social_media_app/components/text_widget.dart';

class DrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onTap;

  const DrawerTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final inversePrimary = Theme.of(context).colorScheme.inversePrimary;
    return ListTile(
      title: Label(
        label: title,
        color: inversePrimary,
      ),
      leading: Icon(
        icon,
        color: primary,
      ),
      onTap: onTap,
    );
  }
}
