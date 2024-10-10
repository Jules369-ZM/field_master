import 'package:flutter/material.dart';

class SheetOption extends StatelessWidget {
  const SheetOption({
    required this.title, required this.icon, required this.onTap, super.key,
    this.color,
  });

  final String title;
  final IconData icon;
  final void Function() onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            color: color ?? Theme.of(context).colorScheme.tertiary,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
      ),
    );
  }
}
