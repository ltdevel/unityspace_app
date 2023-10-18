import 'package:flutter/material.dart';
import 'package:unityspace/widgets/main_form_button_widget.dart';
import 'package:unityspace/widgets/main_form_logo_widget.dart';
import 'package:unityspace/widgets/main_form_text_title_widget.dart';
import 'package:wstore/wstore.dart';

class LoginScreenStore extends WStore {
  // TODO: add data here...

  @override
  LoginScreen get widget => super.widget as LoginScreen;
}

class LoginScreen extends WStoreWidget<LoginScreenStore> {
  const LoginScreen({
    super.key,
  });

  @override
  LoginScreenStore createWStore() => LoginScreenStore();

  @override
  Widget build(BuildContext context, LoginScreenStore store) {
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
              const MainFormTextTitleWidget(text: 'Войдите через'),
              const SizedBox(height: 32),
              Text(
                'или с помощью электронной почты',
                style: TextStyle(
                  fontSize: 14,
                  height: 24 / 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 12),
              MainFormButtonWidget(
                text: 'Ввести емайл',
                onPressed: () {
                  Navigator.pushNamed(context, '/email');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
