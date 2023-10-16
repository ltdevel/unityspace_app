import 'package:flutter/material.dart';

class MainFormButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool loading;

  const MainFormButtonWidget({
    super.key,
    required this.onPressed,
    required this.text,
    this.loading = false,
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
      onPressed: loading ? null : onPressed,
      child: loading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Text(
              text,
              style: const TextStyle(
                color: Color(0xFF111012),
                fontSize: 16,
              ),
            ),
    );
  }
}
