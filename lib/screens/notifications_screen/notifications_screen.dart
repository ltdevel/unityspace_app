import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:unityspace/models/notification_models.dart';
import 'package:unityspace/screens/app_navigation_drawer.dart';
import 'package:unityspace/store/notifications_store.dart';
import 'package:unityspace/utils/logger_plugin.dart';
import 'package:wstore/wstore.dart';
import 'package:unityspace/utils/localization_helper.dart';

enum NotificationErrors { none, loadingDataError }

class NotificationsScreenStore extends WStore {
  NotificationErrors error = NotificationErrors.none;
  WStoreStatus status = WStoreStatus.init;
  int maxPageCount = 1;

  List<NotificationModel>? get notifications => computedFromStore(
        store: NotificationsStore(),
        getValue: (store) => store.notifications,
        keyName: 'notifcations',
      );
  void loadData() {
    if (status == WStoreStatus.loading) return;
    //
    setStore(() {
      status = WStoreStatus.loading;
      error = NotificationErrors.none;
    });
    //
    subscribe(
      subscriptionId: 1,
      future: NotificationsStore().getNotificationsData(page: 1),
      onData: (value) {
        maxPageCount = value;
        setStore(() {
          status = WStoreStatus.loaded;
        });
      },
      onError: (e, stack) {
        logger.d('LoadingScreenStore loadData error=$e\nstack=$stack');
        setStore(() {
          status = WStoreStatus.error;
          error = NotificationErrors.loadingDataError;
        });
      },
    );
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
        body: WStoreStatusBuilder(
          store: store,
          watch: (store) => store.status,
          builderError: (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                "произошла ошибка",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF111012).withOpacity(0.8),
                  fontSize: 20,
                  height: 1.2,
                ),
              ),
            );
          },
          builderLoading: (context) {
            return Center(
              child: Lottie.asset(
                'assets/animations/main_loader.json',
                width: 200,
                height: 200,
              ),
            );
          },
          builder: (context, _) {
            return WStoreBuilder<NotificationsScreenStore>(
                store: store,
                watch: (store) => [store.notifications],
                builder: (context, store) {
                  return ListView.builder(
                    itemCount: store.notifications?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                            height: 90,
                            child: Text("${store.notifications?[index].text}")),
                      );
                    },
                  );
                });
          },
          onStatusLoaded: (context) {},
        ));
  }
}
