import 'package:flutter/material.dart';
import 'package:unityspace/screens/widgets/app_dialog/app_dialog_with_buttons.dart';

/// Диалог при достижении лимита добавления пространств
///
/// @param showTrialButton - показывать ли кнопку попробовать бесплатно
///
/// Возвращает:
/// 'goto_pay' - если нажали обновить тариф
/// или
/// 'start_trial' - если нажали попробовать бесплатно
Future<String?> showAddSpaceLimitDialog(
  BuildContext context, {
  required final bool showTrialButton,
}) async {
  return showDialog<String?>(
    context: context,
    builder: (context) {
      return AddSpaceLimitDialog(showTrialButton: showTrialButton);
    },
  );
}

class AddSpaceLimitDialog extends StatelessWidget {
  final bool showTrialButton;

  const AddSpaceLimitDialog({
    super.key,
    required this.showTrialButton,
  });

  @override
  Widget build(BuildContext context) {
    return AppDialogWithButtons(
      title: 'Вы нашли платную функцию',
      primaryButtonText: 'Обновить',
      onPrimaryButtonPressed: () {
        Navigator.of(context).pop('goto_pay');
      },
      secondaryButtonText: showTrialButton ? 'Попробовать бесплатно' : '',
      onSecondaryButtonPressed: () {
        Navigator.of(context).pop('start_trial');
      },
      children: const [
        Text(
          'Обновите ваш тарифный план, чтобы иметь возможность неограниченно '
          'добавлять пространства',
        ),
      ],
    );
  }
}
