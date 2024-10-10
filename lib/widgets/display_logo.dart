import 'package:flutter/material.dart';

Widget displayLogoPng({
  double width = 70,
  double height = 70,
  String logo = 'logo1',
}) {
  return Image.asset(
    'assets/$logo.png',
    width: width,
    height: height,
    fit: BoxFit.fitWidth,
  );
}
