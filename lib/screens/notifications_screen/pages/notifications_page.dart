import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:unityspace/models/user_models.dart';
import 'package:unityspace/screens/notifications_screen/widgets/notifications_list.dart';
import 'package:unityspace/store/user_store.dart';
import 'package:wstore/wstore.dart';
import 'package:unityspace/models/notification_models.dart';
import 'package:unityspace/utils/errors.dart';
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
  NotificationPageStore(
      {NotificationsStore? notificationsStore, UserStore? userStore})
      : notificationsStore = notificationsStore ?? NotificationsStore(),
        userStore = userStore ?? UserStore();
  //
  NotificationErrors error = NotificationErrors.none;
  WStoreStatus status = WStoreStatus.init;
  int currentPage = 1;
  int maxPageCount = 1;
  NotificationsStore notificationsStore;
  UserStore userStore;
  List<NotificationModel> get notifications => computedFromStore(
        store: notificationsStore,
        getValue: (store) => store.notifications,
        keyName: 'notifcations',
      );

  List<OrganizationMember> get organizationMembers => computedFromStore(
        store: UserStore(),
        getValue: (store) => store.organization?.members ?? [],
        keyName: 'organization_members',
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
      List<NotificationModel> notificationList, bool archived) {
    final notificationIds =
        notificationList.map((notification) => notification.id).toList();
    notificationsStore.changeArchiveStatusNotifications(
        notificationIds, archived);
  }

  ///Изменяет статус прочтения уведомления
  void changeReadStatusNotification(
      List<NotificationModel> notificationList, bool unread) {
    final notificationIds =
        notificationList.map((notification) => notification.id).toList();
    notificationsStore.changeReadStatusNotification(notificationIds, unread);
  }

  ///Архивирует все уведомления
  void archiveAllNotifications() {
    notificationsStore.archiveAllNotifications();
  }

  ///Читает все уведомления
  void readAllNotifications() {
    notificationsStore.readAllNotifications();
  }

  Future<void> loadData() async {
    if (status == WStoreStatus.loading) return;
    setStore(() {
      status = WStoreStatus.loading;
      error = NotificationErrors.none;
    });
    try {
      maxPageCount =
          await notificationsStore.getNotificationsData(page: currentPage);
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
        return const SizedBox.shrink();
      },
      builderLoaded: (context) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                    onTap: () {
                      context
                          .wstore<NotificationPageStore>()
                          .archiveAllNotifications();
                    },
                    child: Text(localization.archive_all)),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                    onTap: () {
                      context
                          .wstore<NotificationPageStore>()
                          .readAllNotifications();
                    },
                    child: Text(localization.read_all)),
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
                    context.wstore<NotificationPageStore>().nextPage();
                  }
                }
                return true;
              },
              child: WStoreBuilder<NotificationPageStore>(
                  watch: (store) => [store.notifications],
                  store: context.wstore<NotificationPageStore>(),
                  builder: (context, store) {
                    final List<NotificationModel> notifications =
                        store.notifications;
                    return NotificationsList(
                      items: notifications,
                      onOptionalButtonTap: (List<NotificationModel> list) {
                        store.changeReadStatusNotification(
                            list, list.any((element) => element.unread));
                      },
                      onArchiveButtonTap: (List<NotificationModel> list) {
                        store.changeArchiveStatusNotifications(
                            list, list.any((element) => element.archived));
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
