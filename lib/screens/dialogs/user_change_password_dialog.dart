import 'package:unityspace/screens/widgets/app_dialog/app_dialog_input_field.dart';
import 'package:unityspace/screens/widgets/app_dialog/app_dialog_with_buttons.dart';

import 'package:flutter/material.dart';
import 'package:unityspace/store/user_store.dart';
import 'package:unityspace/utils/logger_plugin.dart';
import 'package:wstore/wstore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> showUserChangePasswordDialog(
  BuildContext context,
) async {
  return showDialog(
    context: context,
    builder: (context) {
      return const UserChangePasswordDialog();
    },
  );
}

class UserChangePasswordDialogStore extends WStore {
  String oldPassword = '';
  String newPassword = '';
  String confirmPassword = '';
  String changePasswordError = '';
  WStoreStatus statusChange = WStoreStatus.init;

  void setOldPassword(String value) {
    setStore(() {
      oldPassword = value;
    });
  }

  void setNewPassword(String value) {
    setStore(() {
      newPassword = value;
    });
  }

  void setConfirmPassword(String value) {
    setStore(() {
      confirmPassword = value;
    });
  }

  void changePassword() {
    if (statusChange == WStoreStatus.loading) return;
    //
    setStore(() {
      statusChange = WStoreStatus.loading;
      changePasswordError = '';
    });
    //
    if (oldPassword.isEmpty || newPassword.isEmpty) {
      setStore(() {
        changePasswordError = 'Пароль не может быть пустым';
        statusChange = WStoreStatus.error;
      });
      return;
    }
    //
    if (newPassword.length < 8) {
      setStore(() {
        changePasswordError = 'Пароль должен быть не менее 8 символов';
        statusChange = WStoreStatus.error;
      });
      return;
    }
    //
    if (confirmPassword != newPassword) {
      setStore(() {
        changePasswordError = 'Пароли не совпадают';
        statusChange = WStoreStatus.error;
      });
      return;
    }
    //
    if (oldPassword == newPassword) {
      setStore(() {
        changePasswordError = 'Новый пароль должен отличаться от старого';
        statusChange = WStoreStatus.error;
      });
      return;
    }
    //
    subscribe(
      future: UserStore().setUserPassword(oldPassword, newPassword),
      subscriptionId: 1,
      onData: (_) {
        setStore(() {
          statusChange = WStoreStatus.loaded;
        });
      },
      onError: (error, stack) {
        String errorText =
            'При смене пароля возникла проблема, пожалуйста, попробуйте ещё раз';
        if (error == 'Incorrect old password') {
          errorText = 'Старый пароль введен некорректно';
        } else {
          logger.d(
              'UserChangePasswordDialogStore.changePassword error: $error stack: $stack');
        }
        setStore(() {
          statusChange = WStoreStatus.error;
          changePasswordError = errorText;
        });
      },
    );
  }

  @override
  UserChangePasswordDialog get widget =>
      super.widget as UserChangePasswordDialog;
}

class UserChangePasswordDialog
    extends WStoreWidget<UserChangePasswordDialogStore> {
  const UserChangePasswordDialog({
    super.key,
  });

  @override
  UserChangePasswordDialogStore createWStore() =>
      UserChangePasswordDialogStore();

  @override
  Widget build(BuildContext context, UserChangePasswordDialogStore store) {
    final localization = AppLocalizations.of(context);
    return WStoreStatusBuilder(
      store: store,
      watch: (store) => store.statusChange,
      onStatusLoaded: (context) {
        Navigator.of(context).pop();
      },
      builder: (context, status) {
        final loading = status == WStoreStatus.loading;
        final error = status == WStoreStatus.error;
        return AppDialogWithButtons(
          title: localization!.change_password,
          primaryButtonText: localization.save,
          onPrimaryButtonPressed: () {
            FocusScope.of(context).unfocus();
            store.changePassword();
          },
          primaryButtonLoading: loading,
          secondaryButtonText: '',
          children: [
            Text(
              '${localization.come_up_with_a_new_password} (${localization.at_least_8_characters})',
            ),
            const SizedBox(height: 16),
            AddDialogInputField(
              autofocus: true,
              obscureText: true,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.visiblePassword,
              onChanged: (value) {
                store.setOldPassword(value);
              },
              labelText: localization.enter_old_password,
            ),
            const SizedBox(height: 16),
            AddDialogInputField(
              textInputAction: TextInputAction.next,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              onChanged: (value) {
                store.setNewPassword(value);
              },
              labelText: localization.enter_new_password,
            ),
            const SizedBox(height: 16),
            AddDialogInputField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              onChanged: (value) {
                store.setConfirmPassword(value);
              },
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                store.changePassword();
              },
              labelText: localization.repeat_new_password,
            ),
            if (error)
              Text(
                store.changePasswordError,
                style: const TextStyle(
                  color: Color(0xFFD83400),
                ),
              ),
          ],
        );
      },
    );
  }
}
