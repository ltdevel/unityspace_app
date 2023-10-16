import 'package:flutter/material.dart';
import 'package:unityspace/widgets/main_form_button_widget.dart';

class MainFormWidget extends StatefulWidget {
  final String submitButtonText;
  final VoidCallback onSubmit;
  final bool submittingNow;
  final List<Widget> children;

  const MainFormWidget({
    super.key,
    required this.submitButtonText,
    required this.onSubmit,
    required this.submittingNow,
    required this.children,
  });

  @override
  State<MainFormWidget> createState() => _MainFormWidgetState();
}

class _MainFormWidgetState extends State<MainFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...widget.children,
          const SizedBox(height: 12),
          MainFormButtonWidget(
            loading: widget.submittingNow,
            text: widget.submitButtonText,
            onPressed: () {
              FormState? formState = _formKey.currentState;
              if (formState != null && formState.validate()) {
                formState.save();
                widget.onSubmit();
              }
            },
          ),
        ],
      ),
    );
  }
}
