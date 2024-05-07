import 'package:unityspace/models/notification_models.dart';
import 'package:unityspace/service/notification_service.dart' as api;
import 'package:wstore/wstore.dart';

class NotificationsStore extends GStore {
  static NotificationsStore? _instance;

  factory NotificationsStore() => _instance ??= NotificationsStore._();

  NotificationsStore._();

  List<NotificationResponse>? notifications;

  Future<void> getNotificationsData({required int page}) async {
    final notificationsData = await api.getNotificationsOnPage(page: page);
    final notifications = notificationsData.notifications;
    setStore(() {
      this.notifications = notifications;
    });
  }

  @override
  void clear() {
    super.clear();
    setStore(() {
      notifications = null;
    });
  }
}
