import 'package:flutter/material.dart';
import 'package:unityspace/plugins/wstore_plugin.dart';
import 'package:unityspace/screens/widgets/main_form_input_field.dart';
import 'package:unityspace/screens/widgets/main_form_logo_widget.dart';
import 'package:unityspace/screens/widgets/main_form_text_subtitle_widget.dart';
import 'package:unityspace/screens/widgets/main_form_text_title_widget.dart';
import 'package:unityspace/screens/widgets/main_form_widget.dart';
import 'package:unityspace/store/auth_store.dart';
import 'package:wstore/wstore.dart';

class RestorePasswordScreenStore extends WStore {
  WStoreStatus status = WStoreStatus.init;
  String restoreError = '';
  String email = '';

  void again() {
    if (status != WStoreStatus.loaded) return;
    //
    setStore(() {
      status = WStoreStatus.init;
    });
  }

  void restore() {
    if (status == WStoreStatus.loading) return;
    //
    setStore(() {
      status = WStoreStatus.loading;
    });
    //
    subscribe(
      future: AuthStore().restorePasswordByEmail(email),
      subscriptionId: 1,
      onData: (_) {
        setStore(() {
          status = WStoreStatus.loaded;
        });
      },
      onError: (error, __) {
        String errorText =
            'При восстановлении пароля возникла проблема, пожалуйста, попробуйте ещё раз';
        if (error == 'Incorrect user name') {
          errorText = 'Такого аккаунта не существует';
        }
        setStore(() {
          status = WStoreStatus.error;
          restoreError = errorText;
        });
      },
    );
  }

  @override
  RestorePasswordScreen get widget => super.widget as RestorePasswordScreen;
}

class RestorePasswordScreen extends WStoreWidget<RestorePasswordScreenStore> {
  const RestorePasswordScreen({
    super.key,
  });

  @override
  RestorePasswordScreenStore createWStore() => RestorePasswordScreenStore();

  @override
  Widget build(BuildContext context, RestorePasswordScreenStore store) {
    return Scaffold(
      backgroundColor: const Color(0xFF111012),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            children: [
              const SizedBox(height: 60),
              const MainFormLogoWidget(),
              const SizedBox(height: 32),
              const MainFormTextTitleWidget(text: 'Восстановить пароль'),
              const SizedBox(height: 32),
              Expanded(
                child: WStoreStatusBuilder(
                  store: store,
                  watch: (store) => store.status,
                  builder: (context) {
                    final loading = store.status == WStoreStatus.loading;
                    return RestorePasswordForm(loading: loading);
                  },
                  builderLoaded: (context) {
                    return const SentPasswordForm();
                  },
                  onStatusError: (context) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(store.restoreError),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RestorePasswordForm extends StatelessWidget {
  final bool loading;

  const RestorePasswordForm({
    super.key,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return MainFormWidget(
      additionalButtonText: 'Вспомнили? Выполните вход',
      onAdditionalButton: () {
        Navigator.of(context).pop();
      },
      submitButtonText: 'Восстановить пароль',
      onSubmit: () {
        FocusScope.of(context).unfocus();
        // загрузка и вход
        context.wstore<RestorePasswordScreenStore>().restore();
      },
      submittingNow: loading,
      children: (submit) => [
        const MainFormTextSubtitleWidget(
          text:
              'Мы вышлем вам сообщение для восстановления пароля на вашу электронную почту',
        ),
        const SizedBox(height: 12),
        MainFormInputField(
          enabled: !loading,
          autofocus: true,
          labelText: 'Ваша электронная почта',
          iconAssetName: 'assets/icons/email.svg',
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          validator: (text) {
            if (text.isEmpty) return 'Поле не заполнено';
            if (!RegExp(r'\S+@\S+\.\S+').hasMatch(text)) {
              return 'Введите корректный email';
            }
            return '';
          },
          onSaved: (value) {
            context.wstore<RestorePasswordScreenStore>().email = value;
          },
        ),
      ],
    );
  }
}

class SentPasswordForm extends StatelessWidget {
  const SentPasswordForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MainFormWidget(
      additionalButtonText: 'Не получили email? Отправить повторно',
      onAdditionalButton: () {
        context.wstore<RestorePasswordScreenStore>().again();
      },
      submitButtonText: 'Войти по емайл',
      onSubmit: () {
        Navigator.of(context).pop();
      },
      submittingNow: false,
      children: (submit) => [
        const MainFormTextSubtitleWidget(
          text: 'Письмо отправлено на Ваш емейл',
        ),
      ],
    );
  }
}
