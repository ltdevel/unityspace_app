import 'package:flutter/material.dart';
import 'package:unityspace/utils/wstore_plugin.dart';
import 'package:unityspace/screens/widgets/main_form/main_form_input_field.dart';
import 'package:unityspace/screens/widgets/main_form/main_form_logo_widget.dart';
import 'package:unityspace/screens/widgets/main_form/main_form_text_subtitle_widget.dart';
import 'package:unityspace/screens/widgets/main_form/main_form_widget.dart';
import 'package:unityspace/store/auth_store.dart';
import 'package:wstore/wstore.dart';

class ConfirmScreenStore extends WStore {
  WStoreStatus status = WStoreStatus.init;
  String confirmError = '';
  String code = '';

  void confirm() {
    if (status == WStoreStatus.loading) return;
    //
    setStore(() {
      status = WStoreStatus.loading;
    });
    //
    subscribe(
      future: AuthStore().confirmEmail(widget.email, code),
      subscriptionId: 1,
      onData: (_) {
        setStore(() {
          status = WStoreStatus.loaded;
        });
      },
      onError: (error, __) {
        String errorText =
            'При подтверждении почты возникла проблема, пожалуйста, попробуйте ещё раз';
        if (error == 'Error while entering code') {
          errorText = 'Введен неверный код';
        }
        setStore(() {
          status = WStoreStatus.error;
          confirmError = errorText;
        });
      },
    );
  }

  @override
  ConfirmScreen get widget => super.widget as ConfirmScreen;
}

class ConfirmScreen extends WStoreWidget<ConfirmScreenStore> {
  final String email;

  const ConfirmScreen({
    super.key,
    required this.email,
  });

  @override
  ConfirmScreenStore createWStore() => ConfirmScreenStore();

  @override
  Widget build(BuildContext context, ConfirmScreenStore store) {
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
              const MainFormTextSubtitleWidget(
                text:
                'Чтобы завершить регистрацию, введите код, отправленный на Ваш адрес электронной почты',
              ),
              const SizedBox(height: 32),
              Expanded(
                child: WStoreStatusBuilder(
                  store: store,
                  watch: (store) => store.status,
                  builder: (context) {
                    final loading = store.status == WStoreStatus.loading;
                    return ConfirmForm(loading: loading);
                  },
                  onStatusError: (context) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(store.confirmError),
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

class ConfirmForm extends StatelessWidget {
  final bool loading;

  const ConfirmForm({
    super.key,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return MainFormWidget(
      additionalButtonText: 'Не тот email? Зарегистрируйтесь на другой',
      onAdditionalButton: () {
        Navigator.of(context).pop();
      },
      submitButtonText: 'Подтвердить',
      onSubmit: () {
        FocusScope.of(context).unfocus();
        // загрузка и вход
        context.wstore<ConfirmScreenStore>().confirm();
      },
      submittingNow: loading,
      children: (submit) => [
        MainFormInputField(
          enabled: !loading,
          autofocus: true,
          labelText: 'Введите код',
          iconAssetName: 'assets/icons/code.svg',
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          autocorrect: false,
          validator: (text) {
            if (text.isEmpty) return 'Поле не заполнено';
            if (!RegExp(r'\d{4,}').hasMatch(text)) {
              return 'Введите корректный код';
            }
            return '';
          },
          onEditingComplete: () {
            submit();
          },
          onSaved: (value) {
            context.wstore<ConfirmScreenStore>().code = value;
          },
        ),
      ],
    );
  }
}
