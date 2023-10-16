import 'package:flutter/material.dart';
import 'package:unityspace/widgets/main_form_button_widget.dart';
import 'package:unityspace/widgets/main_form_logo_widget.dart';
import 'package:unityspace/widgets/main_form_text_title_widget.dart';
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
              //
              const SizedBox(height: 12),
              MainFormButtonWidget(
                text: 'Войти',
                onPressed: () {
                  // загрузка и вход
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
