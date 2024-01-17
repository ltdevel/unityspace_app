import 'dart:convert';
import 'dart:typed_data';

import 'package:unityspace/service/files_service.dart' as api_files;

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
  final key = await api_files.uploadAvatarByChunks(file: avatarImage);
  final response = await HttpPlugin().post('/user/avatar', {
    'key': key,
  });
  final jsonData = json.decode(response.body);
  final result = UserResponse.fromJson(jsonData);
  return result;
}

Future<UserResponse> setUserName(final String userName) async {
  final response = await HttpPlugin().patch('/user/name', {
    'name': userName,
  });
  final jsonData = json.decode(response.body);
  final result = UserResponse.fromJson(jsonData);
  return result;
}

Future<UserResponse> setJobTitle(final String jobTitle) async {
  final response = await HttpPlugin().patch('/user/job-title', {
    'jobTitle': jobTitle,
  });
  final jsonData = json.decode(response.body);
  final result = UserResponse.fromJson(jsonData);
  return result;
}

Future<UserResponse> setUserGitHubLink(final String githubLink) async {
  final response = await HttpPlugin().patch('/user/github-link', {
    'githubLink': githubLink,
  });
  final jsonData = json.decode(response.body);
  final result = UserResponse.fromJson(jsonData);
  return result;
}

Future<UserResponse> setUserTelegramLink(final String link) async {
  final response = await HttpPlugin().patch('/user/link', {
    'link': link,
  });
  final jsonData = json.decode(response.body);
  final result = UserResponse.fromJson(jsonData);
  return result;
}

Future<UserResponse> setUserBirthday(final String? date) async {
  final response = await HttpPlugin().patch('/user/edit-birthdate', {
    'birthDate': date,
  });
  final jsonData = json.decode(response.body);
  final result = UserResponse.fromJson(jsonData);
  return result;
}
