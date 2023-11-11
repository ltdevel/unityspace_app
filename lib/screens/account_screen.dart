import 'package:flutter/material.dart';
import 'package:unityspace/screens/app_navigaion_drawer.dart';
import 'package:unityspace/store/auth_store.dart';
import 'package:unityspace/widgets/color_button_widget.dart';
import 'package:wstore/wstore.dart';

class AccountScreenStore extends WStore {
  // TODO: add data here...

  @override
  AccountScreen get widget => super.widget as AccountScreen;
}

class AccountScreen extends WStoreWidget<AccountScreenStore> {
  const AccountScreen({
    super.key,
  });

  @override
  AccountScreenStore createWStore() => AccountScreenStore();

  @override
  Widget build(BuildContext context, AccountScreenStore store) {
    return Scaffold(
      drawer: const AppNavigationDrawer(),
      appBar: AppBar(
        title: const Text('Аккаунт'),
      ),
      body: Center(
        child: ColorButtonWidget(
          width: double.infinity,
          onPressed: () {
            AuthStore().signOut();
          },
          text: 'Выйти из аккаунта',
          loading: false,
          colorBackground: const Color(0xFF111012),
          colorText: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }
}
