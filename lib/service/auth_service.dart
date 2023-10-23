import 'dart:convert';

import 'package:unityspace/models/auth_models.dart';
import 'package:unityspace/plugins/http_plugin.dart';

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
        return throw 'Incorrect user name or password';
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
