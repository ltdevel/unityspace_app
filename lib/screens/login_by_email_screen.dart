import 'package:flutter/material.dart';
import 'package:unityspace/widgets/main_form_input_field.dart';
import 'package:unityspace/widgets/main_form_logo_widget.dart';
import 'package:unityspace/widgets/main_form_text_title_widget.dart';
import 'package:unityspace/widgets/main_form_widget.dart';
import 'package:wstore/wstore.dart';

class LoginByEmailScreenStore extends WStore {
  // TODO: add data here...

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
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
          child: Column(
            children: [
              const MainFormLogoWidget(),
              const SizedBox(height: 32),
              const MainFormTextTitleWidget(text: 'Войти по емайл'),
              const SizedBox(height: 32),
              MainFormWidget(
                submitButtonText: 'Войти',
                onSubmit: () {
                  // загрузка и вход
                },
                submittingNow: false,
                children: [
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
