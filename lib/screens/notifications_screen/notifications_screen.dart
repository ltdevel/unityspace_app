import 'package:flutter/material.dart';
import 'package:unityspace/screens/app_navigation_drawer.dart';
import 'package:unityspace/store/notifications_store.dart';
import 'package:wstore/wstore.dart';
import 'package:unityspace/utils/localization_helper.dart';

class NotificationsScreenStore extends WStore {
  void loadData() {
    NotificationsStore().getNotificationsData(page: 1);
  }

  @override
  NotificationsScreen get widget => super.widget as NotificationsScreen;
}

class NotificationsScreen extends WStoreWidget<NotificationsScreenStore> {
  const NotificationsScreen({
    super.key,
  });

  @override
  NotificationsScreenStore createWStore() =>
      NotificationsScreenStore()..loadData();

  @override
  Widget build(BuildContext context, NotificationsScreenStore store) {
    final localization = LocalizationHelper.getLocalizations(context);
    return Scaffold(
      drawer: const AppNavigationDrawer(),
      appBar: AppBar(
        title: Text(localization.notifications),
      ),
      body: Container(),
    );
  }
}
