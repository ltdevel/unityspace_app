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
  int currentPage = 1;
  int maxPageCount = 1;
  NotificationsStore notificationsStore;
  List<NotificationModel> notifications = [];
  //

  void nextPage() {
    if (currentPage < maxPageCount) {
      setStore(() {
        currentPage += 1;
      });
      loadData();
    }
  }

  void changeArchiveStatusNotification(
      List<int> notificationIds, bool archived) async {
    await notificationsStore.changeArchiveStatusNotification(
        notificationIds, archived);
    setStore(() {
      notifications = notificationsStore.notifications;
    });
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
      notifications = notificationsStore.notifications;
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
        return const SizedBox.shrink();
      },
      builderLoaded: (context) {
        return const NotificationsList();
      },
    );
  }
}

class NotificationsList extends StatelessWidget {
  const NotificationsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        if (notification.metrics.atEdge) {
          if (notification.metrics.pixels != 0) {
            debugPrint('scrolled down');
            context.wstore<NotificationPageStore>().nextPage();
          }
        }
        return true;
      },
      child: WStoreValueBuilder(
          watch: (store) => [store.notifications],
          store: context.wstore<NotificationPageStore>(),
          builder: (context, store) {
            final List<NotificationModel> notifications = store[0];
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Colors.white,
                  child: ListTile(
                    title: Text(notifications[index].taskName ?? ''),
                    subtitle: Text(notifications[index].text),
                    trailing: InkWell(
                      onTap: () {
                        context
                            .wstore<NotificationPageStore>()
                            .changeArchiveStatusNotification(
                                [notifications[index].id],
                                !notifications[index].archived);
                      },
                      child: const Text("Архивировать"),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
