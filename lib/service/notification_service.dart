import 'dart:convert';

import 'package:unityspace/models/notification_models.dart';
import 'package:unityspace/utils/http_plugin.dart';

Future<PaginatedNotifications> getNotificationsOnPage(
    {required int page}) async {
  final response = await HttpPlugin().get('/notifications/$page');
  final jsonData = json.decode(response.body);
  final result = PaginatedNotifications.fromJson(jsonData);
  return result;
}

Future<PaginatedNotifications> getArchivedNotificationsOnPage(
    {required int page}) async {
  final response = await HttpPlugin().get('/notifications/archived/$page');
  final jsonData = json.decode(response.body);
  final result = PaginatedNotifications.fromJson(jsonData);
  return result;
}

Future<List<NotificationResponse>> readNotification(
    {required List<int> notificationIds, required bool status}) async {
  final response = await HttpPlugin().patch('/notifications/read-many',
      {"notificationIds": notificationIds, "unread": status});
  final List jsonData = json.decode(response.body);
  return jsonData
      .map((element) => NotificationResponse.fromJson(element))
      .toList();
}

Future<List<NotificationResponse>> archiveNotification(
    {required List<int> notificationIds, required bool isArchived}) async {
  final response = await HttpPlugin().patch('/notifications/archive-many',
      {"notificationIds": notificationIds, "archived": isArchived});
  final List jsonData = json.decode(response.body);
  return jsonData
      .map((element) => NotificationResponse.fromJson(element))
      .toList();
}

Future<List<NotificationResponse>> unarchiveNotification(
    {required int notificationId, required bool archived}) async {
  final response = await HttpPlugin().patch(
    '/notifications/$notificationId/unarchive',
  );
  final jsonData = json.decode(response.body);
  return jsonData
      .map((element) => NotificationResponse.fromJson(element))
      .toList();
}

Future<List<NotificationResponse>> readAllNotifications() async {
  final response = await HttpPlugin().patch(
    '/notifications/read',
  );
  final List jsonData = json.decode(response.body);
  return jsonData
      .map((element) => NotificationResponse.fromJson(element))
      .toList();
}

Future<List<NotificationResponse>> archiveAllNotifications() async {
  final response = await HttpPlugin().patch(
    '/notifications/archive',
  );
  final List jsonData = json.decode(response.body);
  return jsonData
      .map((element) => NotificationResponse.fromJson(element))
      .toList();
}

Future<DeleteNotificationsResponse> deleteAllNotifications() async {
  final response = await HttpPlugin().patch(
    '/notifications/delete',
  );
  final jsonData = json.decode(response.body);
  return DeleteNotificationsResponse.fromJson(jsonData);
}

Future<DeleteNotificationsResponse> deleteNotification({
  required List<int> notificationIds,
}) async {
  final response = await HttpPlugin().delete('notifications/delete-many', {
    "notificationIds": notificationIds,
  });
  final jsonData = json.decode(response.body);
  return DeleteNotificationsResponse.fromJson(jsonData);
}
