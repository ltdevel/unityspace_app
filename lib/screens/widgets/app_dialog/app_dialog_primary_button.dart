import 'package:flutter/material.dart';
import 'package:unityspace/screens/widgets/color_button_widget.dart';

class AppDialogPrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool loading;

  const AppDialogPrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return ColorButtonWidget(
      width: double.infinity,
      onPressed: () {
        onPressed?.call();
      },
      text: text,
      loading: loading,
      colorBackground: const Color(0xFF111012),
      colorText: Colors.white,
    );
  }
}
