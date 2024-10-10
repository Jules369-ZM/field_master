import 'package:flutter/material.dart';
import 'package:field_master/utils/size_config.dart';

class AppListViewPage extends StatelessWidget {
  const AppListViewPage({
    required this.children,
    super.key,
    this.paddingHorizontal = 32,
    this.paddingVertical = 32,
  });
  final List<Widget> children;
  final double paddingHorizontal;
  final double paddingVertical;
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics()
          .applyTo(const ClampingScrollPhysics()),
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(paddingHorizontal),
        vertical: getProportionateScreenWidth(paddingVertical),
      ),
      children: children,
    );
  }
}
