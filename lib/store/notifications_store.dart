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

  /// Возвращает отформатированный список,
  /// в котором обновлен статус прочитано/непрочитано у
  /// уведомления
  List<NotificationModel> _readLocally({
    required List<NotificationResponse> notificationsToUpdate,
    required List<NotificationModel> notifications,
  }) {
    final newNotifications = [...notifications];
    List<int> notificationIdsToUpdate =
        notificationsToUpdate.map((e) => e.id).toList();

    // Проходим по всем уведомлениям и обновляем их статус, если их идентификатор присутствует в списке для обновления
    for (var notification in newNotifications) {
      if (notificationIdsToUpdate.contains(notification.id)) {
        notification.unread = !notification.unread;
      }
    }
    return newNotifications;
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
    notifications.addAll(newNotifications);
    final copyNotifications = [...notifications];

    // Обновление списка уведомлений в сторе
    setStore(() {
      notifications = copyNotifications;
    });

    // Возврат максимального количества страниц
    return notificationsData.maxPagesCount;
  }

  /// Меняет статус по Архивированию уведомлений по id тех уведомлений,
  /// которые мы укажем
  Future<void> changeArchiveStatusNotification(
      List<int> notificationIds, bool isArchived) async {
    final archivedList = await api.archiveNotification(
        notificationIds: notificationIds, isArchived: !isArchived);
    setStore(() {
      notifications = _archiveLocally(
          notificationsToRemove: archivedList, notifications: notifications);
    });
  }

  /// Меняет статус по Прочтению уведомлений по id тех уведомлений,
  /// которые мы укажем
  Future<void> changeReadStatusNotification(
      List<int> notificationIds, bool isUnread) async {
    final readList = await api.readNotification(
        notificationIds: notificationIds, status: !isUnread);
    setStore(() {
      notifications = _readLocally(
          notificationsToUpdate: readList, notifications: notifications);
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

  /// Читает все уведомления
  Future<void> readAllNotifications() async {
    final readList = await api.readAllNotifications();
    setStore(() {
      notifications = _readLocally(
          notificationsToUpdate: readList, notifications: notifications);
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
