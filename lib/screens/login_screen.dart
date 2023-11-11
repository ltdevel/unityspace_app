import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:unityspace/plugins/logger_plugin.dart';
import 'package:unityspace/plugins/wstore_plugin.dart';
import 'package:unityspace/screens/widgets/main_form_button_widget.dart';
import 'package:unityspace/screens/widgets/main_form_logo_widget.dart';
import 'package:unityspace/screens/widgets/main_form_text_button_widget.dart';
import 'package:unityspace/screens/widgets/main_form_text_title_widget.dart';
import 'package:unityspace/screens/widgets/sign_in_button_widget.dart';
import 'package:unityspace/store/auth_store.dart';
import 'package:wstore/wstore.dart';

class LoginScreenStore extends WStore {
  WStoreStatus statusGoogle = WStoreStatus.init;
  String googleError = '';
  GoogleSignIn googleSignIn = GoogleSignIn();

  void google() {
    if (statusGoogle == WStoreStatus.loading) return;
    //
    setStore(() {
      statusGoogle = WStoreStatus.loading;
    });
    //
    subscribe(
      future: _googleSignInAction(),
      subscriptionId: 1,
      onData: (_) {
        setStore(() {
          statusGoogle = WStoreStatus.loaded;
        });
      },
      onError: (error, __) {
        logger.d('google sign in error=$error');
        setStore(() {
          statusGoogle = WStoreStatus.error;
          googleError =
              'При входе через Google возникла проблема, пожалуйста, попробуйте ещё раз';
        });
      },
    );
  }

  Future<void> _googleSignInAction() async {
    GoogleSignInAccount? account = await googleSignIn.signIn();
    if (account != null) {
      GoogleSignInAuthentication auth = await account.authentication;
      if (auth.accessToken != null) {
        await AuthStore().googleAuth(auth.accessToken!);
        googleSignIn.disconnect();
      } else {
        googleSignIn.disconnect();
        throw 'no accessToken';
      }
    }
  }

  // Future<void> _yandexSignInAction() async {
  //   final flutterLoginYandexPlugin = FlutterLoginYandex();
  //   final response = await flutterLoginYandexPlugin.signIn();
  //   if (response!=null) {
  //     final token = response['token'] as String?;
  //     if (token == null) {
  //       throw 'no token';
  //     }
  //     logger.d('yandex token=$token');
  //   }
  // }

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
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            children: [
              const SizedBox(height: 60),
              const MainFormLogoWidget(),
              const SizedBox(height: 32),
              const MainFormTextTitleWidget(text: 'Войдите через'),
              const SizedBox(height: 32),
              Row(
                children: [
                  WStoreStatusBuilder(
                    store: store,
                    watch: (store) => store.statusGoogle,
                    builder: (context) {
                      final loading =
                          store.statusGoogle == WStoreStatus.loading;
                      return SignInButtonWidget(
                        loading: loading,
                        iconAssetName: 'assets/icons/google.svg',
                        width: 0,
                        text: 'Google',
                        onPressed: () {
                          store.google();
                        },
                      );
                    },
                    onStatusError: (context) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(store.googleError),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                child: MainFormTextButtonWidget(
                  text: 'Нет учетной записи? Зарегистрируйтесь',
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
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
