import 'package:flutter/material.dart';
import 'package:unityspace/screens/widgets/main_form/main_form_input_field.dart';
import 'package:unityspace/screens/widgets/main_form/main_form_logo_widget.dart';
import 'package:unityspace/screens/widgets/main_form/main_form_text_button_widget.dart';
import 'package:unityspace/screens/widgets/main_form/main_form_text_title_widget.dart';
import 'package:unityspace/screens/widgets/main_form/main_form_widget.dart';
import 'package:unityspace/store/auth_store.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wstore/wstore.dart';
import 'package:unityspace/utils/localization_helper.dart';

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
    final localization = LocalizationHelper.getLocalizations(context);
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
              MainFormTextTitleWidget(text: localization.creating_account),
              const SizedBox(height: 32),
              Expanded(
                child: WStoreStatusBuilder(
                  store: store,
                  watch: (store) => store.status,
                  builder: (context, status) {
                    final loading = status == WStoreStatus.loading;
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
    final localization = LocalizationHelper.getLocalizations(context);
    return MainFormWidget(
      additionalButtonText: localization.you_already_have_account_login,
      onAdditionalButton: () {
        Navigator.of(context).pop();
      },
      submitButtonText: localization.create_account,
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
          labelText: localization.your_email,
          iconAssetName: 'assets/icons/email.svg',
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          validator: (text) {
            if (text.isEmpty) return localization.the_field_is_not_filled_in;
            if (!RegExp(r'\S+@\S+\.\S+').hasMatch(text)) {
              return localization.enter_correct_email;
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
              labelText:
                  '${localization.come_up_with_a_new_password} (${localization.at_least_8_characters})',
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
                if (text.isEmpty) {
                  return localization.the_field_is_not_filled_in;
                }
                if (text.length < 8) {
                  return '${localization.password_must_be_at_least} 8 ${localization.characters}';
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
            text: localization.by_registering_accept_privacy_policy,
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
