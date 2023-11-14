import 'package:flutter/material.dart';

class MainFormTextSubtitleWidget extends StatelessWidget {
  final String text;

  const MainFormTextSubtitleWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: Colors.white.withOpacity(0.9),
      ),
    );
  }
}
