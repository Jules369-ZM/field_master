// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';

import '../utils/utils.dart';

Future<bool?> generalDialog(
  String body, {
  String title = 'Confirm',
}) async {
  return showDialog<bool>(
    barrierDismissible: false,
    context: navKey.currentContext!,
    builder: (BuildContext ctxt_) {
      return AlertDialog(
        title: Text(title),
        titleTextStyle: TextStyle(
          fontSize: 18,
          color: Theme.of(navKey.currentContext!).colorScheme.primary,
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                body,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctxt_, false);
            },
            child: Text(
              'No',
              style: TextStyle(
                color: Theme.of(navKey.currentContext!).colorScheme.secondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctxt_, true);
            },
            child: Text(
              'Yes',
              style: TextStyle(
                color: Theme.of(navKey.currentContext!).colorScheme.secondary,
              ),
            ),
          ),
        ],
      );
    },
  );
}
