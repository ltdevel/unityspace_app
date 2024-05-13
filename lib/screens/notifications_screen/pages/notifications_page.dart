import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wstore/wstore.dart';
import 'package:unityspace/models/notification_models.dart';
import 'package:unityspace/screens/notifications_screen/utils/notification_errors.dart';
import 'package:unityspace/store/notifications_store.dart';
import 'package:unityspace/utils/localization_helper.dart';
import 'package:unityspace/utils/logger_plugin.dart';

/// Стор страницы уведомлений
///
/// Слой логики
///
/// Содержит в себе методы получения и обработки уведомлений пользователя
class NotificationPageStore extends WStore {
  //
  NotificationPageStore({NotificationsStore? notificationsStore})
      : notificationsStore = notificationsStore ?? NotificationsStore();
  //
  NotificationErrors error = NotificationErrors.none;
  WStoreStatus status = WStoreStatus.init;
  int maxPageCount = 1;
  NotificationsStore notificationsStore;
  List<NotificationModel>? get notifications => computedFromStore(
        store: notificationsStore,
        getValue: (store) => store.notifications,
        keyName: 'notifcations',
      );
  //
  Future<void> loadData() async {
    if (status == WStoreStatus.loading) return;
    setStore(() {
      status = WStoreStatus.loading;
      error = NotificationErrors.none;
    });
    try {
      maxPageCount = await notificationsStore.getNotificationsData(page: 1);
      setStore(() {
        status = WStoreStatus.loaded;
      });
    } catch (e, stack) {
      logger.d('on NotificationsPage'
          'NotificationsStore loadData error=$e\nstack=$stack');
      setStore(() {
        status = WStoreStatus.error;
        error = NotificationErrors.loadingDataError;
      });
    }
  }

  @override
  NotificationsPage get widget => super.widget as NotificationsPage;
}

/// Страница Уведомлений
///
/// UI Слой
///
/// Наследуется от WstoreWidget,
class NotificationsPage extends WStoreWidget<NotificationPageStore> {
  const NotificationsPage({
    super.key,
  });

  @override
  NotificationPageStore createWStore() =>
      NotificationPageStore(notificationsStore: NotificationsStore())
        ..loadData();

  @override
  Widget build(BuildContext context, NotificationPageStore store) {
    final localization = LocalizationHelper.getLocalizations(context);
    return WStoreStatusBuilder(
      store: store,
      watch: (store) => store.status,
      builderError: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Text(
            switch (store.error) {
              NotificationErrors.none => "",
              NotificationErrors.loadingDataError =>
                localization.problem_uploading_data_try_again
            },
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
        return ListView.builder(
          itemCount: store.notifications?.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: Colors.white,
              child: ListTile(
                title: Text(store.notifications?[index].taskName ?? ''),
                subtitle:  Text("${store.notifications?[index].text}"),
              ),
            );
          },
        );
      },
    );
  }
}
