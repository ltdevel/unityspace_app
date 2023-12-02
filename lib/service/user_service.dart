import 'dart:convert';
import 'dart:typed_data';

import 'package:unityspace/service/files_service.dart' as apiFiles;

import 'package:unityspace/models/user_models.dart';
import 'package:unityspace/utils/http_plugin.dart';

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

Future<UserResponse> removeUserAvatar() async {
  final response = await HttpPlugin().patch('/user/removeAvatar');
  final jsonData = json.decode(response.body);
  final result = UserResponse.fromJson(jsonData);
  return result;
}

Future<UserResponse> setUserAvatar(final Uint8List avatarImage) async {
  final key = await apiFiles.uploadAvatarByChunks(file: avatarImage);
  final response = await HttpPlugin().post('/user/avatar', {
    'key': key,
  });
  final jsonData = json.decode(response.body);
  final result = UserResponse.fromJson(jsonData);
  return result;
}
