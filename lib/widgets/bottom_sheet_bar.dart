// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';
import 'package:field_master/utils/size_config.dart';

DecoratedBox bottomSheetAppBar(BuildContext context, String text) {
  return DecoratedBox(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.cancel,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    ),
  );
}
