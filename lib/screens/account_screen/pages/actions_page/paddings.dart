import 'package:flutter/material.dart';

class PaddingTop extends StatelessWidget {
  const PaddingTop(
    this.padding, {
    super.key,
    this.child,
  });

  final double padding;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: padding),
      child: child,
    );
  }
}
