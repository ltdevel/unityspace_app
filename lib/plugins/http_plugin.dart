import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:unityspace/plugins/logger_plugin.dart';

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

  Future<http.Response> post(final String url, Object? data) async {
    try {
      final uri = _makeUri(url);
      logger.d('POST REQUEST to $url: $data');
      final response = await _client.post(uri, body: data, headers: _headers);
      logger.d(
          'POST RESPONSE status = ${response.statusCode} body = ${response.body}');
      if (response.statusCode == 200) return response;
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
      logger.d('POST RESPONSE exception = ${e.toString()}');
      if (e is http.ClientException) {
        throw HttpPluginException(-1, e.message, 'ClientException');
      }
      rethrow;
    }
  }

  Future<http.Response> patch(final String url, Object? data) async {
    try {
      final uri = _makeUri(url);
      logger.d('PATCH REQUEST to $url: $data');
      final response = await _client.patch(uri, body: data, headers: _headers);
      logger.d(
        'PATCH RESPONSE status = ${response.statusCode} body = ${response.body}',
      );
      if (response.statusCode == 200) return response;
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
      logger.d('PATCH RESPONSE exception = ${e.toString()}');
      if (e is http.ClientException) {
        throw HttpPluginException(-1, e.message, 'ClientException');
      }
      rethrow;
    }
  }

  Uri _makeUri(final String url) {
    if (_scheme == 'https') return Uri.https(_host, url);
    return Uri.http(_host, url);
  }
}
