import 'package:flutter/material.dart';
import 'package:unityspace/widgets/main_form_input_field.dart';
import 'package:unityspace/widgets/main_form_logo_widget.dart';
import 'package:unityspace/widgets/main_form_text_title_widget.dart';
import 'package:unityspace/widgets/main_form_widget.dart';
import 'package:wstore/wstore.dart';

class LoginByEmailScreenStore extends WStore {
  bool showPassword = false;

  void toggleShowPassword() {
    setStore(() {
      showPassword = !showPassword;
    });
  }

  @override
  LoginByEmailScreen get widget => super.widget as LoginByEmailScreen;
}

class LoginByEmailScreen extends WStoreWidget<LoginByEmailScreenStore> {
  const LoginByEmailScreen({
    super.key,
  });

  @override
  LoginByEmailScreenStore createWStore() => LoginByEmailScreenStore();

  @override
  Widget build(BuildContext context, LoginByEmailScreenStore store) {
    return Scaffold(
      backgroundColor: const Color(0xFF111012),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Column(
            children: [
              const SizedBox(height: 60),
              const MainFormLogoWidget(),
              const SizedBox(height: 32),
              const MainFormTextTitleWidget(text: 'Войти по емайл'),
              const SizedBox(height: 32),
              Expanded(
                child: MainFormWidget(
                  submitButtonText: 'Войти',
                  onSubmit: () {
                    FocusScope.of(context).unfocus();
                    // загрузка и вход
                  },
                  submittingNow: false,
                  children: (submit) => [
                    MainFormInputField(
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
                    ),
                    const SizedBox(height: 12),
                    WStoreValueBuilder<LoginByEmailScreenStore, bool>(
                      store: store,
                      watch: (store) => store.showPassword,
                      builder: (context, showPassword) {
                        return MainFormInputField(
                          labelText: 'Ваш пароль',
                          iconAssetName: showPassword
                              ? 'assets/icons/password_hide.svg'
                              : 'assets/icons/password_show.svg',
                          textInputAction: TextInputAction.done ,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !showPassword,
                          autocorrect: false,
                          enableSuggestions: false,
                          onIconTap: () {
                            store.toggleShowPassword();
                          },
                          onEditingComplete: () {
                            submit();
                          },
                          validator: (text) {
                            if (text.isEmpty) return 'Поле не заполнено';
                            return '';
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
