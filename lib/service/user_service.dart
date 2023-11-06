import 'dart:convert';

import 'package:unityspace/models/user_models.dart';
import 'package:unityspace/plugins/http_plugin.dart';

Future<UserResponse> getUserData() async {
  final response = await HttpPlugin().get('/user/me');
  final jsonData = json.decode(response.body);
  final result = UserResponse.fromJson(jsonData);
  return result;
}

Future<OrganizationResponse> getOrganizationData() async {
  final response = await HttpPlugin().get('/user/organization');
  final jsonData = json.decode(response.body);
  final result = OrganizationResponse.fromJson(jsonData);
  return result;
}
