import 'dart:convert';

import 'package:unityspace/models/auth_models.dart';
import 'package:unityspace/plugins/http_plugin.dart';

Future<RegisterResponse> register({
  required final String email,
  required final String password,
}) async {
  try {
    final response = await HttpPlugin().post('/auth/register', {
      'email': email.toLowerCase(),
      'password': password,
    });
    final jsonData = json.decode(response.body);
    final result = RegisterResponse.fromJson(jsonData);
    return result;
  } catch (e) {
    if (e is HttpPluginException) {
      if (e.message == 'User is already exists') {
        throw 'User already exists';
      }
      if (e.message == 'incorrect or non-exist Email') {
        throw 'non-exist Email';
      }
      if (e.statusCode == 500 && e.message.contains('554')) {
        throw 'too many messages';
      }
    }
    rethrow;
  }
}

Future<OnlyTokensResponse> confirmEmail({
  required final String email,
  required final String code,
}) async {
  try {
    final response =
        await HttpPlugin().post('/auth/verify-email-registration', {
      'email': email,
      'code': code,
      'referrer': null,
    });
    final jsonData = json.decode(response.body);
    final result = OnlyTokensResponse.fromJson(jsonData);
    return result;
  } catch (e) {
    if (e is HttpPluginException) {
      if (e.message == 'Error while verifying email') {
        throw 'Error while entering code';
      }
    }
    rethrow;
  }
}

Future<OnlyTokensResponse> login({
  required final String email,
  required final String password,
}) async {
  try {
    final response = await HttpPlugin().post('/auth/login', {
      'email': email,
      'password': password,
    });
    final jsonData = json.decode(response.body);
    final result = OnlyTokensResponse.fromJson(jsonData);
    return result;
  } catch (e) {
    if (e is HttpPluginException) {
      if (e.message == 'Credentials incorrect') {
        throw 'Incorrect user name or password';
      }
    }
    rethrow;
  }
}

Future<void> signOut({
  required final String refreshToken,
  required final int globalUserId,
}) async {
  await HttpPlugin().patch('/auth/logout', {
    'refreshToken': refreshToken,
    'userId': globalUserId,
  });
}

Future<OnlyTokensResponse> refreshAccessToken({
  required final String refreshToken,
}) async {
  final response = await HttpPlugin().get('/auth/refresh', {
    'refreshToken': refreshToken,
  });
  final jsonData = json.decode(response.body);
  final result = OnlyTokensResponse.fromJson(jsonData);
  return result;
}

Future<void> restorePasswordByEmail({
  required final String email,
}) async {
  try {
    final response = await HttpPlugin().post('/auth/reset-password', {
      'email': email,
    });
    final jsonData = json.decode(response.body);
    final result = ResetPasswordResponse.fromJson(jsonData);
    if (result.status != 'ok') {
      if (result.message == 'Credentials incorrect') {
        throw 'Incorrect user name';
      }
      throw '${result.status}: ${result.message}';
    }
  } catch (e) {
    if (e is HttpPluginException) {
      if (e.message == 'Credentials incorrect') {
        throw 'Incorrect user name';
      }
    }
    rethrow;
  }
}
