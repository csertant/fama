import 'package:intl/intl.dart';

abstract class AppDateFormat {
  static final DateFormat dateOnly = DateFormat('y. MM. dd.');
  static final DateFormat dateTime = DateFormat('y. MM. dd. HH:mm');
  static final DateFormat full = DateFormat('y. MM. dd. HH:mm:ss');
}
