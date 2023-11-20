import 'package:flutter/material.dart';
import 'package:unityspace/screens/app_navigation_drawer.dart';
import 'package:wstore/wstore.dart';

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
    return Scaffold(
      drawer: const AppNavigationDrawer(),
      appBar: AppBar(
        title:  const Text('Уведомления'),
      ),
      body: Container(),
    );
  }
}
