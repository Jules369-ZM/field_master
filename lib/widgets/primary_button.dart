// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';

import '../utils/utils.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.title,
    required this.onPressed,
    super.key,
    this.buttonStyle,
  });
  final String title;
  final dynamic Function()? onPressed;
  final ButtonStyle? buttonStyle;

  @override
  Widget build(BuildContext context) {
    final isShort = Screen.heightInches(context) < 4.5;
    return ElevatedButton(
      onPressed: onPressed,
      style: buttonStyle ??
          ElevatedButton.styleFrom(
            backgroundColor:
                Theme.of(navKey.currentContext!).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            minimumSize: Size.fromHeight(isShort ? 48 : 56),
            // foregroundColor: Colors.grey[300],
          ),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(navKey.currentContext!).colorScheme.onPrimary,
        ),
      ),
    );
  }
}

ButtonStyle buildButtonStyle({Color? primary}) {
  return ElevatedButton.styleFrom(
    // elevation: 4,
    textStyle: TextStyle(
      fontWeight: FontWeight.w600,
      color: Theme.of(navKey.currentContext!).colorScheme.onPrimary,
      fontSize: 18,
    ),
    backgroundColor:
        primary ?? Theme.of(navKey.currentContext!).colorScheme.onSecondary,
    minimumSize: const Size(double.infinity, 40),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );
}
