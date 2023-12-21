import 'package:string_validator/string_validator.dart';
import 'package:unityspace/utils/http_plugin.dart';

String? makeAvatarUrl(final String? avatar) {
  return avatar != null ? '${HttpPlugin.baseURL}/files/avatar/$avatar' : null;
}

String? getNullStringIfEmpty(final String? str) {
  return str == null || str.isEmpty ? null : str;
}

double makeOrderFromInt(final int order) {
  return order / 1000000.0;
}

int makeIntFromOrder(final double order) {
  return (order * 1000000).toInt();
}

bool isLinkValid(final String url) {
  return isURL(url, {
    'protocols': ['http', 'https'],
    'require_protocol': true
  });
}
