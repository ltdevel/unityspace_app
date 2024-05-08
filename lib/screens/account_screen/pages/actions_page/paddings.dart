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

class PaddingBottom extends StatelessWidget {
  const PaddingBottom(
    this.padding, {
    super.key,
    this.child,
  });

  final double padding;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding),
      child: child,
    );
  }
}

class PaddingHorizontal extends StatelessWidget {
  const PaddingHorizontal(this.padding, {super.key, this.child});

  final double padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: child,
    );
  }
}
