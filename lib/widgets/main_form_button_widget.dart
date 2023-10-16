import 'package:flutter/material.dart';

class MainFormButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const MainFormButtonWidget({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      minWidth: double.infinity,
      height: 40,
      elevation: 2,
      color: Colors.white,
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF111012),
          fontSize: 16,
        ),
      ),
    );
  }
}
