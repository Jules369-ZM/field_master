// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';

import '../utils/utils.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    super.key,
    this.message = Strings.loading,
  });
  final String message;
  @override
  Widget build(BuildContext context) {
    return Align(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator.adaptive(),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
