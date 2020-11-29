import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/timeago.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Utils {


  static void showToast(String mess, {int time = 1}) {
    EasyLoading.showToast(mess,
        duration: new Duration(seconds: time),
        toastPosition: EasyLoadingToastPosition.center);
  }

  static void onLoading() {
    EasyLoading.show(status: 'loading...');
  }

  static String getTimeAgo(DateTime time) {
    timeago.setLocaleMessages('custom', CustomMessages());
    return timeago.format(time, locale: 'custom'); // 15m
  }

  static String currentDateTime(){
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
  String aboutAMonth(int days) => '1mo';

  @override
  String months(int months) => '$months' 'mo';

  @override
  String aboutAYear(int year) => '1y';

  @override
  String years(int years) => '$years' 'y';

  @override
  String wordSeparator() => ' ';
}
