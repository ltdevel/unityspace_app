import 'package:flutter/material.dart';
import 'package:unityspace/utils/wstore_plugin.dart';
import 'package:unityspace/screens/widgets/main_form_input_field.dart';
import 'package:unityspace/screens/widgets/main_form_logo_widget.dart';
import 'package:unityspace/screens/widgets/main_form_text_button_widget.dart';
import 'package:unityspace/screens/widgets/main_form_text_title_widget.dart';
import 'package:unityspace/screens/widgets/main_form_widget.dart';
import 'package:unityspace/store/auth_store.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wstore/wstore.dart';

class RegisterScreenStore extends WStore {
  WStoreStatus status = WStoreStatus.init;
  String registerError = '';
  String email = '';
  String password = '';
  bool showPassword = false;

  void toggleShowPassword() {
    setStore(() {
      showPassword = !showPassword;
    });
  }

  void register() {
    if (status == WStoreStatus.loading) return;
    //
    setStore(() {
      status = WStoreStatus.loading;
    });
    //
    subscribe(
      future: AuthStore().register(email, password),
      subscriptionId: 1,
      onData: (_) {
        setStore(() {
          status = WStoreStatus.loaded;
        });
      },
      onError: (error, __) {
        String errorText =
            'При создании учетной записи возникла проблема, пожалуйста, попробуйте ещё раз';
        if (error == 'User already exists') {
          errorText = 'Такой email уже зарегистрирован!';
        }
        if (error == 'non-exist Email') {
          errorText = 'Некорректный email';
        }
        if (error == 'too many messages') {
          errorText =
              'Почтовый сервис перегружен, попробуйте повторить попытку через 15 минут';
        }
        setStore(() {
          status = WStoreStatus.error;
          registerError = errorText;
        });
      },
    );
  }

  @override
  RegisterScreen get widget => super.widget as RegisterScreen;
}

class RegisterScreen extends WStoreWidget<RegisterScreenStore> {
  const RegisterScreen({
    super.key,
  });

  @override
  RegisterScreenStore createWStore() => RegisterScreenStore();

  @override
  Widget build(BuildContext context, RegisterScreenStore store) {
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
              const MainFormTextTitleWidget(text: 'Создание аккаунта'),
              const SizedBox(height: 32),
              Expanded(
                child: WStoreStatusBuilder(
                  store: store,
                  watch: (store) => store.status,
                  builder: (context) {
                    final loading = store.status == WStoreStatus.loading;
                    return RegisterByEmailForm(loading: loading);
                  },
                  onStatusLoaded: (context) {
                    // переходим на экран подтверждения
                    Navigator.pushNamed(
                      context,
                      '/confirm',
                      arguments: store.email,
                    );
                  },
                  onStatusError: (context) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(store.registerError),
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

class RegisterByEmailForm extends StatelessWidget {
  final bool loading;

  const RegisterByEmailForm({
    super.key,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return MainFormWidget(
      additionalButtonText: 'У вас есть учетная запись? Выполните вход',
      onAdditionalButton: () {
        Navigator.of(context).pop();
      },
      submitButtonText: 'Создать аккаунт',
      onSubmit: () {
        FocusScope.of(context).unfocus();
        // загрузка и вход
        context.wstore<RegisterScreenStore>().register();
      },
      submittingNow: loading,
      children: (submit) => [
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
            context.wstore<RegisterScreenStore>().email = value;
          },
        ),
        const SizedBox(height: 12),
        WStoreValueBuilder<RegisterScreenStore, bool>(
          watch: (store) => store.showPassword,
          builder: (context, showPassword) {
            return MainFormInputField(
              enabled: !loading,
              labelText: 'Придумайте пароль (не менее 8 символов)',
              iconAssetName: showPassword
                  ? 'assets/icons/password_hide.svg'
                  : 'assets/icons/password_show.svg',
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
              obscureText: !showPassword,
              autocorrect: false,
              enableSuggestions: false,
              onIconTap: () {
                context.wstore<RegisterScreenStore>().toggleShowPassword();
              },
              onEditingComplete: () {
                submit();
              },
              validator: (text) {
                if (text.isEmpty) return 'Поле не заполнено';
                if (text.length < 8) {
                  return 'Пароль должен быть не менее 8 символов';
                }
                return '';
              },
              onSaved: (value) {
                context.wstore<RegisterScreenStore>().password = value;
              },
            );
          },
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: MainFormTextButtonWidget(
            text:
                'Регистрируясь, я принимаю условия Политики конфиденциальности и Публичной оферты',
            onPressed: () async {
              final url = Uri.parse('https://www.unityspace.ru/privacy-policy');
              await launchUrl(url, mode: LaunchMode.externalApplication);
            },
          ),
        ),
      ],
    );
  }
}
