// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';

import '../utils/utils.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.title, required this.onPressed, super.key,
  });
  final String title;
  final  void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final isShort = Screen.heightInches(context) < 4.5;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        foregroundColor: Theme.of(context).colorScheme.onTertiary,
        minimumSize: Size.fromHeight(isShort ? 48 : 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text(title),
    );
  }
}
