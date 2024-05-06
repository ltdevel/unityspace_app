import 'package:flutter/material.dart';
import 'package:unityspace/screens/app_navigation_drawer.dart';
import 'package:wstore/wstore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsScreenStore extends WStore {
  // TODO: add data here...

  @override
  NotificationsScreen get widget => super.widget as NotificationsScreen;
}

class NotificationsScreen extends WStoreWidget<NotificationsScreenStore> {
  const NotificationsScreen({
    super.key,
  });

  @override
  NotificationsScreenStore createWStore() => NotificationsScreenStore();

  @override
  Widget build(BuildContext context, NotificationsScreenStore store) {
    final localization = AppLocalizations.of(context);
    return Scaffold(
      drawer: const AppNavigationDrawer(),
      appBar: AppBar(
        title: Text(localization!.notifications),
      ),
      body: Container(),
    );
  }
}
