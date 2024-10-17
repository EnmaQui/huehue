import 'package:flutter/material.dart';

class BaseListWidget extends StatelessWidget {
  const BaseListWidget({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
    this.scrollDirection = Axis.vertical,
    this.spacing = 12,
  });

  final int itemCount;
  final EdgeInsetsGeometry? padding;
  final Axis scrollDirection;
  final Widget? Function(BuildContext, int) itemBuilder;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: scrollDirection,
      physics: const BouncingScrollPhysics(),
      itemCount: itemCount,
      padding: padding,
      separatorBuilder: (context, index) {
        return SizedBox(
          width: scrollDirection == Axis.horizontal ? spacing : 0,
          height: scrollDirection == Axis.vertical ? spacing : 0,
        );
      },
      itemBuilder: itemBuilder,
    );
  }
}
