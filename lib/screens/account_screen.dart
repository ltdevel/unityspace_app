import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unityspace/screens/app_navigation_drawer.dart';
import 'package:unityspace/screens/widgets/tabs_list/tab_button.dart';
import 'package:unityspace/screens/widgets/tabs_list/tabs_list_row.dart';
import 'package:unityspace/store/auth_store.dart';
import 'package:wstore/wstore.dart';

class AccountScreenStore extends WStore {
  bool isExiting = false;
  String selectedTab = AccountScreenTab.account.name;

  void selectTab(final String tab) {
    setStore(() {
      selectedTab = tab;
    });
  }

  void init(final String tab) {
    final tabName = tab.isEmpty ? AccountScreenTab.account.name : tab;
    selectTab(AccountScreenTab.values.byName(tabName).name);
  }

  @override
  AccountScreen get widget => super.widget as AccountScreen;
}

enum AccountScreenTab {
  account(title: 'Аккаунт'),
  achievements(title: 'Достижения'),
  actions(title: 'Мои действия'),
  settings(title: 'Настройки'),
  members(title: 'Участники организации'),
  tariff(title: 'Оплата и тарифы', iconAsset: 'assets/icons/tab_license.svg');

  const AccountScreenTab({
    required this.title,
    this.iconAsset,
  });

  final String title;
  final String? iconAsset;
}

class AccountScreen extends WStoreWidget<AccountScreenStore> {
  final String tab;
  final String action;

  const AccountScreen({
    super.key,
    required this.tab,
    required this.action,
  });

  @override
  AccountScreenStore createWStore() => AccountScreenStore()..init(tab);

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
      body: Column(
        children: [
          WStoreValueBuilder(
            store: store,
            watch: (store) => store.selectedTab,
            builder: (context, selectedTab) => TabsListRow(
              children: [
                ...AccountScreenTab.values.map(
                  (tab) => TabButton(
                    iconAsset: tab.iconAsset,
                    title: tab.title,
                    onPressed: () {
                      store.selectTab(tab.name);
                    },
                    selected: tab.name == store.selectedTab,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
