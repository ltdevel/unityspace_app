import 'package:flutter/material.dart';
import 'package:unityspace/widgets/main_form_button_widget.dart';

class MainFormWidget extends StatefulWidget {
  final String submitButtonText;
  final VoidCallback onSubmit;
  final bool submittingNow;
  final List<Widget> Function(VoidCallback submit) children;

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

  void submit() {
    FormState? formState = _formKey.currentState;
    if (formState != null && formState.validate()) {
      formState.save();
      widget.onSubmit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                ...widget.children(submit),
              ],
            ),
          ),
          const SizedBox(height: 12),
          MainFormButtonWidget(
            loading: widget.submittingNow,
            text: widget.submitButtonText,
            onPressed: submit,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
