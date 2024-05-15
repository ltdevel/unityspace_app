import 'package:intl/intl.dart';
import 'package:string_validator/string_validator.dart';
import 'package:unityspace/utils/http_plugin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

String timeAgo({
  required String date,
  required AppLocalizations localizations,
}) {
  DateTime dateTime = dateFromDateString(date);
  Duration diff = DateTime.now().difference(dateTime);

  if (diff.inDays >= 365) {
    final years = (diff.inDays / 365).floor();
    return localizations.yearsAgo(years, years);
  } else if (diff.inDays >= 30) {
    final months = (diff.inDays / 30).floor();
    return localizations.monthsAgo(months, months);
  } else if (diff.inDays >= 7) {
    final weeks = (diff.inDays / 7).floor();
    return localizations.weeksAgo(weeks, weeks);
  } else if (diff.inDays >= 2) {
    final days = diff.inDays.toInt();
    return localizations.daysAgo(days, days);
  } else if (diff.inHours >= 1) {
    return localizations.yesterday;
  } else {
    return localizations.today;
  }
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

String formatDate({required String dateString, required String locale}) {
  DateTime date = DateTime.parse(dateString);
  DateFormat formatter = DateFormat('EEEE, d MMMM', locale);
  String formattedDate = formatter.format(date);
  return formattedDate.capitalizeWords();
}

extension StringExtension on String {
  String capitalizeWords() {
    List<String> words = split(' ');

    return words
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }
}
