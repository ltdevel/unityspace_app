import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:unityspace/plugins/logger_plugin.dart';
import 'package:unityspace/store/auth_store.dart';

class HttpPluginException implements Exception {
  final int statusCode;
  final String message;
  final String error;

  const HttpPluginException(this.statusCode, this.message, this.error);

  @override
  String toString() {
    return 'HttpPluginException{statusCode: $statusCode, message: $message, error: $error}';
  }
}

class HttpPlugin {
  static const _baseURL = 'https://server.unityspace.ru';

  static HttpPlugin? _instance;

  factory HttpPlugin() => _instance ??= HttpPlugin._();

  final http.Client _client = http.Client();
  late final String _host;
  late final String _scheme;
  final Map<String, String> _headers = {};

  HttpPlugin._() {
    final uri = Uri.parse(_baseURL);
    _host = uri.host;
    _scheme = uri.scheme;
  }

  void setAuthorizationHeader(final String authorization) {
    if (authorization.isEmpty) {
      _headers.remove('Authorization');
      return;
    }
    _headers['Authorization'] = authorization;
  }

  Future<http.Response> post(
    final String url, [
    final Map<String, dynamic>? data,
  ]) {
    return send('POST', url, data);
  }

  Future<http.Response> patch(
    final String url, [
    final Map<String, dynamic>? data,
  ]) {
    return send('PATCH', url, data);
  }

  Future<http.Response> get(
    final String url, [
    Map<String, dynamic>? queryParameters,
  ]) {
    return send('GET', url, null, queryParameters);
  }

  Future<http.Response> send(
    final String method,
    final String url, [
    final Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  ]) async {
    final uri = _makeUri(url, queryParameters);
    final request = http.Request(method, uri);
    request.headers.addAll(_headers);
    if (data != null) {
      request.headers['Content-Type'] = 'application/json; charset=UTF-8';
      request.body = jsonEncode(data);
    }
    try {
      if (data != null) {
        logger.d('$method REQUEST to $url with data = $data');
      } else if (queryParameters != null) {
        logger.d('$method REQUEST to $url with params = $queryParameters');
      } else {
        logger.d('$method REQUEST to $url');
      }
      var responseStream = await _client.send(request);
      var response = await http.Response.fromStream(responseStream);
      if (response.statusCode == 401 && url != '/auth/refresh') {
        // это не запрос на обновление токена и токен протух
        // пытаемся обновить и послать запрос заново
        final needSendAgain = await AuthStore().refreshUserToken();
        if (needSendAgain) {
          // обновляем заголовки (токены авторизации обновились)
          request.headers.addAll(_headers);
          //
          if (data != null) {
            logger.d('RETRY $method REQUEST to $url with data = $data');
          } else if (queryParameters != null) {
            logger.d(
                'RETRY $method REQUEST to $url with params = $queryParameters');
          } else {
            logger.d('RETRY $method REQUEST to $url');
          }
          responseStream = await _client.send(request);
          response = await http.Response.fromStream(responseStream);
        }
      }
      logger.d(
        '$method RESPONSE status = ${response.statusCode} body = ${response.body}',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      }
      final jsonData = json.decode(response.body);
      final message = jsonData['message'];
      throw HttpPluginException(
        response.statusCode,
        message is List<dynamic>
            ? message.firstOrNull?.toString() ?? 'unknown'
            : message?.toString() ?? 'unknown',
        jsonData['error']?.toString() ?? 'unknown',
      );
    } catch (e) {
      logger.d('$method RESPONSE exception = ${e.toString()}');
      if (e is http.ClientException) {
        throw HttpPluginException(-1, e.message, 'ClientException');
      }
      rethrow;
    }
  }

  Uri _makeUri(final String url, [Map<String, dynamic>? queryParameters]) {
    if (_scheme == 'https') return Uri.https(_host, url, queryParameters);
    return Uri.http(_host, url, queryParameters);
  }
}
