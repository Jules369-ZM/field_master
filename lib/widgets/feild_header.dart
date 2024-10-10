// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';

import '../utils/utils.dart';

Widget buildFeildHeader(
  String text, {
  Color? color,
  FontWeight fontWeight = FontWeight.w600,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(
      text,
      style: Theme.of(navKey.currentContext!)
          .textTheme
          .titleSmall!
          .copyWith(color: color, fontWeight: fontWeight),
    ),
  );
}
