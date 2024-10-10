
import 'package:flutter/material.dart';

class ActionSheet extends StatelessWidget {
  const ActionSheet({
    required this.actions,
    super.key,
    this.title = 'Select an option',
    this.subtitle,
  });

  final List<Widget> actions;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      shrinkWrap: true,
      children: [
        ListTile(
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle!) : null,
        ),
        for (final action in actions) ...[
          action,
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 40),
      ],
    );
  }
}
