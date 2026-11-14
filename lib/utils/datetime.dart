import 'package:intl/intl.dart';

abstract final class AppDateFormat {
  static final yMd = DateFormat('y. MM. dd.');
  static final yMdHm = DateFormat('y. MM. dd. HH:mm');
  static final yMdHms = DateFormat('y. MM. dd. HH:mm:ss');
}

abstract final class AppDateUtils {
  static DateTime oneMonthAgo() {
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month - 1,
      now.day,
      now.hour,
      now.minute,
      now.second,
      now.millisecond,
      now.microsecond,
    );
  }

  static DateTime firstPossibleDate() => DateTime(1998);

  static DateTime lastPossibleDate() => DateTime.now();
}
