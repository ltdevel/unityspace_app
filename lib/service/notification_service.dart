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
