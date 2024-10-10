import 'package:flutter/material.dart';

class AppContainer extends StatelessWidget {
  const AppContainer({required this.child, super.key, this.type = 0});
  final Widget child;
  final int type;
  @override
  Widget build(BuildContext context) {
    if (type == 0) {
      return _typeZero(context);
    }
    if (type == 1) {
      return _typeOne(context);
    } else {
      return _typeZero(context);
    }
  }

  Container _typeZero(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(.1),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .onSecondaryContainer
              .withOpacity(.3),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }

  Container _typeOne(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(.1),
        border: Border.all(
          color:
              Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(.3),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
