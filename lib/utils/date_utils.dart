import 'package:intl/intl.dart';

class DateUtils {
  static String formatDateTime(DateTime dateTime, String locale) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final timeFormat = DateFormat('hh:mm a', locale);
    return 'දිනය : ${dateFormat.format(dateTime)}\nවේලාව: ${timeFormat.format(dateTime)}';
  }
}