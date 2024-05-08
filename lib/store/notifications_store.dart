import 'package:unityspace/models/notification_models.dart';
import 'package:unityspace/service/notification_service.dart' as api;
import 'package:wstore/wstore.dart';

class NotificationsStore extends GStore {
  static NotificationsStore? _instance;

  factory NotificationsStore() => _instance ??= NotificationsStore._();

  NotificationsStore._();

  List<NotificationModel>? notifications;

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

  @override
  void clear() {
    super.clear();
    setStore(() {
      notifications = null;
    });
  }
}
