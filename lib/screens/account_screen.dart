import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unityspace/screens/app_navigaion_drawer.dart';
import 'package:unityspace/store/auth_store.dart';
import 'package:wstore/wstore.dart';

class AccountScreenStore extends WStore {
  bool isExiting = false;

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
        title: const Text('Мой профиль'),
        actions: [
          IconButton(
            padding: const EdgeInsets.all(2),
            icon: SvgPicture.asset(
              'assets/icons/sign_out.svg',
              width: 20,
              height: 20,
              theme: SvgTheme(
                currentColor:
                    IconTheme.of(context).color ?? const Color(0xFF111012),
              ),
            ),
            tooltip: 'Выйти из аккаунта',
            onPressed: () async {
              if (store.isExiting) return;
              store.isExiting = true;
              await AuthStore().signOut();
              store.isExiting = false;
            },
          ),
        ],
      ),
      body: Container(),
    );
  }
}
