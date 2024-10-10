import 'dart:io';

import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key, this.color, this.size = 24});
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CircularProgressIndicator.adaptive(backgroundColor: color)
        : SizedBox(
            height: size,
            width: size,
            child: CircularProgressIndicator(
              backgroundColor: color,
              strokeWidth: 2.5,
            ),
          );
  }
}
