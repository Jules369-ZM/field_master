// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'app_loader.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(navKey.currentContext!).colorScheme.primary,
        minimumSize: const Size.fromHeight(40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Loader(color: color),
    );
  }
}
