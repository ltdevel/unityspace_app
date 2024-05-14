import 'package:intl/intl.dart';
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

String timeAgo(String date) {
  DateTime dateTime = dateFromDateString(date);
  Duration diff = DateTime.now().difference(dateTime);
  if (diff.inDays > 365) {
    return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
  }
  if (diff.inDays > 30) {
    return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
  }
  if (diff.inDays > 7) {
    return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
  }
  if (diff.inDays > 1) {
    return "${diff.inDays} days ago";
  }
  if (diff.inDays == 1) {
    return "yesterday";
  }
  return "today";
}

DateTime dateFromDateString(String date) {
  final dateString = date.split('T')[0];
  final dateList = dateString.split('-');
  return DateTime(
    int.parse(dateList[0]),
    int.parse(dateList[1]),
    int.parse(dateList[2]),
  );
}

String timeFromDateString(String date) {
  final timeString = date.split('T')[1];
  final timeList = timeString.split(':');
  return '${timeList[0].padLeft(2, '0')}:${timeList[1].padRight(2, '0')}';
}

String formatDate(String dateString) {
  DateTime date = DateTime.parse(dateString);
  DateFormat formatter = DateFormat('EEEE, d MMMM');
  return formatter.format(date);
}
