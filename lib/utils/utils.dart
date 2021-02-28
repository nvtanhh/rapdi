import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/timeago.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Utils {
  static void showToast(String mess, {int time = 1000}) {
    EasyLoading.showToast(mess,
        duration: new Duration(milliseconds: time),
        toastPosition: EasyLoadingToastPosition.center);
  }

  static void onLoading() {
    EasyLoading.show(status: 'loading...');
  }

  static String getTimeAgo(DateTime time) {
    timeago.setLocaleMessages('custom', CustomMessages());
    return timeago.format(time, locale: 'custom'); // 15m
  }

  static String currentDateTime() {
    DateTime now = DateTime.now();
    return DateFormat('dd-MM-yyyy HH:mm').format(now);
  }
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
  String lessThanOneMinute(int seconds) => '$seconds' ' giây';

  @override
  String aboutAMinute(int minutes) => '1 giây';

  @override
  String minutes(int minutes) => '$minutes' ' phút';

  @override
  String aboutAnHour(int minutes) => '1 giờ';

  @override
  String hours(int hours) => '$hours' ' giờ';

  @override
  String aDay(int hours) => '1 ngày';

  @override
  String days(int days) => '$days' ' ngày';

  @override
  String aboutAMonth(int days) => '1 tháng';

  @override
  String months(int months) => '$months' ' tháng';

  @override
  String aboutAYear(int year) => '1 năm';

  @override
  String years(int years) => '$years' ' năm';

  @override
  String wordSeparator() => ' ';
}
