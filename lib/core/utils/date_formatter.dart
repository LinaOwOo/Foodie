import 'package:intl/intl.dart';

class DateFormatter {
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  static String formatFullDate(DateTime dateTime) {
    return DateFormat('EEEE, MMMM dd, yyyy').format(dateTime);
  }

  static String formatShortDate(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  static String formatDayMonth(DateTime dateTime) {
    return DateFormat('dd MMM').format(dateTime);
  }

  static String formatNumericDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  static bool isToday(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  static bool isYesterday(DateTime dateTime) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day;
  }

  static String formatRelativeDate(DateTime dateTime) {
    if (isToday(dateTime)) {
      return 'Today';
    } else if (isYesterday(dateTime)) {
      return 'Yesterday';
    } else {
      return formatShortDate(dateTime);
    }
  }
}
