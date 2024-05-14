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

Future<NotificationResponse> readNotification(
    {required List<int> notificationIds, required bool status}) async {
  final respone = await HttpPlugin().patch('/notifications/read-many',
      {"notificationIds": notificationIds, "unread": status});
  final jsonData = json.decode(respone.body);
  final response = NotificationResponse.fromJson(jsonData);
  return response;
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

Future<NotificationResponse> readAllNotifications() async {
  final respone = await HttpPlugin().patch(
    '/notifications/read',
  );
  final jsonData = json.decode(respone.body);
  final response = NotificationResponse.fromJson(jsonData);
  return response;
}

Future<List<NotificationResponse>> archiveAllNotifications() async {
  final respone = await HttpPlugin().patch(
    '/notifications/archive',
  );
  final List jsonData = json.decode(respone.body);
  return jsonData
      .map((element) => NotificationResponse.fromJson(element))
      .toList();
}

Future<NotificationResponse> deleteAllNotifications() async {
  final respone = await HttpPlugin().patch(
    '/notifications/delete',
  );
  final jsonData = json.decode(respone.body);
  final response = NotificationResponse.fromJson(jsonData);
  return response;
}

Future<DeleteNotificationsResponse> deleteNotification({
  required List<int> notificationIds,
}) async {
  final respone = await HttpPlugin().patch('notifications/delete-many', {
    "notificationIds": notificationIds,
  });
  final jsonData = json.decode(respone.body);
  final response = DeleteNotificationsResponse.fromJson(jsonData);
  return response;
}
