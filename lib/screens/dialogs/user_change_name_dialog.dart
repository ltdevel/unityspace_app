import 'package:unityspace/screens/widgets/app_dialog/app_dialog_input_field.dart';
import 'package:unityspace/screens/widgets/app_dialog/app_dialog_with_buttons.dart';

import 'package:flutter/material.dart';
import 'package:unityspace/store/user_store.dart';
import 'package:unityspace/utils/logger_plugin.dart';
import 'package:unityspace/utils/wstore_plugin.dart';
import 'package:wstore/wstore.dart';

Future<void> showUserChangeNameDialog(
  BuildContext context,
  final String name,
) async {
  return showDialog(
    context: context,
    builder: (context) {
      return UserChangeNameDialog(name: name);
    },
  );
}

class UserChangeNameDialogStore extends WStore {
  String name = '';
  String changeNameError = '';
  WStoreStatus statusChangeName = WStoreStatus.init;

  void setName(String value) {
    setStore(() {
      name = value;
    });
  }

  void changeName() {
    if (statusChangeName == WStoreStatus.loading) return;
    //
    setStore(() {
      statusChangeName = WStoreStatus.loading;
      changeNameError = '';
    });
    //
    if (name.isEmpty) {
      setStore(() {
        changeNameError = 'Имя не может быть пустым';
        statusChangeName = WStoreStatus.error;
      });
      return;
    }
    //
    if (name == widget.name) {
      setStore(() {
        statusChangeName = WStoreStatus.loaded;
      });
      return;
    }
    //
    subscribe(
      future: UserStore().setUserName(name),
      subscriptionId: 1,
      onData: (_) {
        setStore(() {
          statusChangeName = WStoreStatus.loaded;
        });
      },
      onError: (error, stack) {
        String errorText =
            'При смене имени возникла проблема, пожалуйста, попробуйте ещё раз';
        logger.d(
            'UserChangeNameDialogStore.changeName error: $error stack: $stack');
        setStore(() {
          statusChangeName = WStoreStatus.error;
          changeNameError = errorText;
        });
      },
    );
  }

  @override
  UserChangeNameDialog get widget => super.widget as UserChangeNameDialog;
}

class UserChangeNameDialog extends WStoreWidget<UserChangeNameDialogStore> {
  final String name;

  const UserChangeNameDialog({
    super.key,
    required this.name,
  });

  @override
  UserChangeNameDialogStore createWStore() =>
      UserChangeNameDialogStore()..name = name;

  @override
  Widget build(BuildContext context, UserChangeNameDialogStore store) {
    return WStoreStatusBuilder(
      store: store,
      watch: (store) => store.statusChangeName,
      onStatusLoaded: (context) {
        Navigator.of(context).pop();
      },
      builder: (context, status) {
        final loading = status == WStoreStatus.loading;
        final error = status == WStoreStatus.error;
        return AppDialogWithButtons(
          title: 'Изменить имя',
          primaryButtonText: 'Сохранить',
          onPrimaryButtonPressed: () {
            FocusScope.of(context).unfocus();
            store.changeName();
          },
          primaryButtonLoading: loading,
          secondaryButtonText: '',
          children: [
            AddDialogInputField(
              autofocus: true,
              initialValue: name,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.words,
              onChanged: (value) {
                store.setName(value);
              },
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                store.changeName();
              },
              labelText: 'Введите новое имя',
            ),
            if (error)
              Text(
                store.changeNameError,
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
