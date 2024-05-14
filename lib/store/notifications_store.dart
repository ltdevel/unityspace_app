import 'dart:async';

import 'package:unityspace/models/notification_models.dart';
import 'package:unityspace/service/notification_service.dart' as api;
import 'package:wstore/wstore.dart';

class NotificationsStore extends GStore {
  static NotificationsStore? _instance;

  factory NotificationsStore() => _instance ??= NotificationsStore._();

  NotificationsStore._();

  List<NotificationModel> notifications = [];

  /// Возвращает отформатированный список,
  /// из которого уже убраны отформатированные/вернувшиеся из форматирования
  /// уведомления
  List<NotificationModel> _archiveLocally({
    required List<NotificationResponse> notificationsToRemove,
    required List<NotificationModel> notifications,
  }) {
    List<int> notificationIdsToRemove =
        notificationsToRemove.map((e) => e.id).toList();
    return notifications
        .where((notification) =>
            !notificationIdsToRemove.contains(notification.id))
        .toList();
  }

  Future<int> getNotificationsData(
      {required int page, bool isArchived = false}) async {
    // Получение данных уведомлений
    final PaginatedNotifications notificationsData = isArchived
        ? await api.getArchivedNotificationsOnPage(page: page)
        : await api.getNotificationsOnPage(page: page);

    // Преобразование ответа в список моделей NotificationModel
    List<NotificationModel> newNotifications = notificationsData.notifications
        .map((notification) => NotificationModel.fromResponse(notification))
        .toList();

    // Обновление списка уведомлений в сторе
    setStore(() {
      notifications = newNotifications;
    });

    // Возврат максимального количества страниц
    return notificationsData.maxPagesCount;
  }

  /// Меняет статус уведомлений по id тех уведомлений,
  /// которые мы укажем
  Future<void> changeArchiveStatusNotification(
      List<int> notificationIds, bool isArchived) async {
    final archivedList = await api.archiveNotification(
        notificationIds: notificationIds, isArchived: isArchived);
    setStore(() {
      notifications = _archiveLocally(
          notificationsToRemove: archivedList, notifications: notifications);
    });
  }

  /// Архивирует все уведомления
  Future<void> archiveAllNotifications() async {
    final archivedList = await api.archiveAllNotifications();
    setStore(() {
      notifications = _archiveLocally(
          notificationsToRemove: archivedList, notifications: notifications);
    });
  }

  @override
  void clear() {
    super.clear();
    setStore(() {
      notifications.clear();
    });
  }
}
