import 'package:flutter/material.dart';

Widget subTitle(BuildContext context, String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 16, left: 16),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: Colors.grey.shade600,
          ),
    ),
  );
}
