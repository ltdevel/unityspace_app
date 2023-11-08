import 'package:unityspace/plugins/http_plugin.dart';

String? makeAvatarUrl(final String? avatar) {
  return avatar != null ? '${HttpPlugin.baseURL}/files/avatar/$avatar' : null;
}

double makeOrderFromInt(final int order) {
  return order / 1000000.0;
}
