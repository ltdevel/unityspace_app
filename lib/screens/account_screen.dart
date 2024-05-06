import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unityspace/screens/app_navigation_drawer.dart';
import 'package:unityspace/screens/pages/account_page.dart';
import 'package:unityspace/screens/pages/achievements_page.dart';
import 'package:unityspace/screens/pages/actions_page.dart';
import 'package:unityspace/screens/pages/members_page.dart';
import 'package:unityspace/screens/pages/settings_page.dart';
import 'package:unityspace/screens/pages/tariff_page.dart';
import 'package:unityspace/screens/widgets/tabs_list/tab_button.dart';
import 'package:unityspace/screens/widgets/tabs_list/tabs_list_row.dart';
import 'package:unityspace/store/auth_store.dart';
import 'package:unityspace/store/user_store.dart';
import 'package:unityspace/utils/logger_plugin.dart';
import 'package:wstore/wstore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountScreenStore extends WStore {
  AccountScreenTab selectedTab = AccountScreenTab.account;
  WStoreStatus statusExiting = WStoreStatus.init;
  String exitingError = '';

  bool get isOrganizationOwner => computedFromStore(
        store: UserStore(),
        getValue: (store) => store.isOrganizationOwner,
        keyName: 'isOrganizationOwner',
      );

  List<AccountScreenTab> get currentUserTabs => computed(
        getValue: () {
          if (isOrganizationOwner) return AccountScreenTab.values;
          return AccountScreenTab.values
              .where((tab) => tab.adminOnly == false)
              .toList();
        },
        watch: () => [isOrganizationOwner],
        keyName: 'currentUserTabs',
      );

  void selectTab(final AccountScreenTab tab) {
    setStore(() {
      selectedTab = tab;
    });
  }

  void init(final String tab) {
    final tabName = tab.isEmpty ? AccountScreenTab.account.name : tab;
    selectTab(AccountScreenTab.values.byName(tabName));
  }

  void signOut() {
    if (statusExiting == WStoreStatus.loading) return;
    //
    setStore(() {
      statusExiting = WStoreStatus.loading;
      exitingError = '';
    });
    subscribe(
      future: AuthStore().signOut(),
      subscriptionId: 1,
      onData: (_) {
        setStore(() {
          statusExiting = WStoreStatus.loaded;
        });
      },
      onError: (error, stack) {
        String errorText =
            'При выходе из учетной записи возникла проблема, пожалуйста, попробуйте ещё раз';
        logger.d('AccountScreenStore.signOut error: $error stack: $stack');
        setStore(() {
          statusExiting = WStoreStatus.error;
          exitingError = errorText;
        });
      },
    );
  }

  @override
  AccountScreen get widget => super.widget as AccountScreen;
}

enum AccountScreenTab {
  account(title: 'Аккаунт', adminOnly: false),
  achievements(title: 'Достижения', adminOnly: false),
  actions(title: 'Мои действия', adminOnly: false),
  settings(title: 'Настройки', adminOnly: false),
  members(title: 'Участники организации', adminOnly: true),
  tariff(
    title: 'Оплата и тарифы',
    iconAsset: 'assets/icons/tab_license.svg',
    adminOnly: true,
  );

  const AccountScreenTab({
    required this.title,
    required this.adminOnly,
    this.iconAsset,
  });

  final String title;
  final String? iconAsset;
  final bool adminOnly;
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
    final localization = AppLocalizations.of(context);
    return Scaffold(
      drawer: const AppNavigationDrawer(),
      appBar: AppBar(
        title: Text(localization!.my_profile),
        actions: [
          WStoreStatusBuilder(
            store: store,
            watch: (store) => store.statusExiting,
            builder: (context, status) {
              final loading = status == WStoreStatus.loading;
              return SignOutIconButton(
                onPressed: () => store.signOut(),
                loading: loading,
              );
            },
            onStatusError: (context) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(store.exitingError),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WStoreBuilder(
            store: store,
            watch: (store) => [store.selectedTab, store.currentUserTabs],
            builder: (context, store) => TabsListRow(
              children: [
                ...store.currentUserTabs.map(
                  (tab) => TabButton(
                    iconAsset: tab.iconAsset,
                    title: tab.title,
                    onPressed: () {
                      store.selectTab(tab);
                    },
                    selected: tab == store.selectedTab,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: WStoreValueBuilder(
                store: store,
                watch: (store) => store.selectedTab,
                builder: (context, selectedTab) {
                  return switch (selectedTab) {
                    AccountScreenTab.account => const AccountPage(),
                    AccountScreenTab.achievements => const AchievementsPage(),
                    AccountScreenTab.actions => const ActionsPage(),
                    AccountScreenTab.settings => const SettingsPage(),
                    AccountScreenTab.members => const MembersPage(),
                    AccountScreenTab.tariff => const TariffPage(),
                  };
                }),
          ),
        ],
      ),
    );
  }
}

class SignOutIconButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onPressed;

  const SignOutIconButton({
    super.key,
    required this.onPressed,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final currentColor = IconTheme.of(context).color ?? const Color(0xFF111012);
    return IconButton(
      padding: EdgeInsets.all(loading ? 4 : 2),
      icon: loading
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: currentColor,
              ),
            )
          : SvgPicture.asset(
              'assets/icons/sign_out.svg',
              width: 20,
              height: 20,
              theme: SvgTheme(currentColor: currentColor),
            ),
      tooltip: localization!.logout_from_account,
      onPressed: loading ? null : onPressed,
    );
  }
}
