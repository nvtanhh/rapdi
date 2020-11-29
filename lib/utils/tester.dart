import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/timeago.dart';

void parseJson() async {
  String jsonString = await _loadFromAsset();
  final jsonResponse = jsonDecode(jsonString);
  print(jsonResponse);
}

Future<String> _loadFromAsset() async {
  return await rootBundle.loadString("rhymeResult.json");
}

void testTimeAgo() {
  var time = DateTime.parse("2020-10-22 15:46:02Z");

  timeago.setLocaleMessages('custom', CustomMessages());
  print(timeago.format(time, locale: 'custom')); // 15m
}

void main() {
  testTimeAgo();
}

class CustomMessages implements LookupMessages {
  @override
  String prefixAgo() => '';

  @override
  String prefixFromNow() => '';

  @override
  String suffixAgo() => '';

  @override
  String suffixFromNow() => '';

  @override
  String lessThanOneMinute(int seconds) => '$seconds' 's';

  @override
  String aboutAMinute(int minutes) => '1m';

  @override
  String minutes(int minutes) => '$minutes' 'm';

  @override
  String aboutAnHour(int minutes) => '1h';

  @override
  String hours(int hours) => '$hours' 'h';

  @override
  String aDay(int hours) => '1d';

  @override
  String days(int days) => '$days' 'd';

  @override
  String aboutAMonth(int days) => '~1mo';

  @override
  String months(int months) => '$months' 'mo';

  @override
  String aboutAYear(int year) => '1y';

  @override
  String years(int years) => '$years' 'y';

  @override
  String wordSeparator() => ' ';
}
