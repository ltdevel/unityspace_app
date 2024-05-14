import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:unityspace/models/notification_models.dart';
import 'package:unityspace/screens/notifications_screen/utils/notification_errors.dart';
import 'package:unityspace/screens/notifications_screen/widgets/notifications_list.dart';
import 'package:unityspace/store/notifications_store.dart';
import 'package:unityspace/utils/logger_plugin.dart';
import 'package:wstore/wstore.dart';
import 'package:unityspace/utils/localization_helper.dart';

class ArchivedNotificationPageStore extends WStore {
  //
  ArchivedNotificationPageStore({NotificationsStore? notificationsStore})
      : notificationsStore = notificationsStore ?? NotificationsStore();
  //
  bool isArchived = true;
  NotificationErrors error = NotificationErrors.none;
  WStoreStatus status = WStoreStatus.init;
  int maxPageCount = 1;
  int currentPage = 1;
  NotificationsStore notificationsStore;
  List<NotificationModel> get notifications => computedFromStore(
        store: notificationsStore,
        getValue: (store) => store.notifications,
        keyName: 'notifcations',
      );

  /// Переход на следующую страницу уведомлений
  void nextPage() {
    if (currentPage < maxPageCount) {
      setStore(() {
        currentPage += 1;
      });
      loadData();
    }
  }

  ///Изменяет статус архивирования уведомления
  void changeArchiveStatusNotifications(
      List<int> notificationIds, bool archived) {
    notificationsStore.changeArchiveStatusNotifications(
        notificationIds, archived);
  }

  ///Архивирует все уведомления
  void archiveAllNotifications() {
    notificationsStore.archiveAllNotifications();
  }

  ///Удаляет уведомления
  void deleteNotifications(List<int> notificationIds) {
    notificationsStore.deleteNotifications(notificationIds);
  }

  ///Удаляет все уведомления из архива
  void deleteAllNotifications() {
    notificationsStore.deleteAllNotifications();
  }

  Future<void> loadData() async {
    if (status == WStoreStatus.loading) return;
    setStore(() {
      status = WStoreStatus.loading;
      error = NotificationErrors.none;
    });
    try {
      maxPageCount = await notificationsStore.getNotificationsData(
          page: currentPage, isArchived: isArchived);
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
  void dispose() {
    notificationsStore.clear();
    super.dispose();
  }

  @override
  ArchivedNotificationsPage get widget =>
      super.widget as ArchivedNotificationsPage;
}

class ArchivedNotificationsPage
    extends WStoreWidget<ArchivedNotificationPageStore> {
  const ArchivedNotificationsPage({
    super.key,
  });

  @override
  ArchivedNotificationPageStore createWStore() =>
      ArchivedNotificationPageStore()..loadData();

  @override
  Widget build(BuildContext context, ArchivedNotificationPageStore store) {
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
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                    onTap: () {
                      context
                          .wstore<ArchivedNotificationPageStore>()
                          .deleteAllNotifications();
                    },
                    child: Text(localization.delete_all)),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            Expanded(
                child: NotificationListener<ScrollEndNotification>(
              onNotification: (notification) {
                if (notification.metrics.atEdge) {
                  if (notification.metrics.pixels != 0) {
                    debugPrint('scrolled down');
                    context.wstore<ArchivedNotificationPageStore>().nextPage();
                  }
                }
                return true;
              },
              child: WStoreBuilder<ArchivedNotificationPageStore>(
                  watch: (store) => [store.notifications],
                  store: context.wstore<ArchivedNotificationPageStore>(),
                  builder: (context, store) {
                    final List<NotificationModel> notifications =
                        store.notifications;
                    return NotificationsList(
                      items: notifications,
                      onArchiveButtonTap: (index) {
                        context
                            .wstore<ArchivedNotificationPageStore>()
                            .changeArchiveStatusNotifications(
                                [notifications[index].id],
                                notifications[index].archived);
                      },
                      onOptionalButtonTap: (int index) {
                        context
                            .wstore<ArchivedNotificationPageStore>()
                            .deleteNotifications(
                          [notifications[index].id],
                        );
                      },
                    );
                  }),
            )),
          ],
        );
      },
    );
  }
}
