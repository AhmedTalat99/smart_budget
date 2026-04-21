import 'package:intl/intl.dart';
import 'package:smart_budget/core/constants/app_constants.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat(AppConstants.dateFormat).format(date);
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat(AppConstants.monthYearFormat).format(date);
  }

  // convert number to currency format with 2 decimal places and EGP symbol
  static String formatCurrency(double amount) {
    return NumberFormat("#,##0.00").format(amount);
  }

  static String getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final dateTocheck = DateTime(date.year, date.month, date.day);

    switch (true) {
      case true when dateTocheck == today:
        return 'Today';
      case true when dateTocheck == yesterday:
        return 'Yesterday';
      case true when now.difference(date).inDays < 7:
        return DateFormat('EEEE').format(date);
      default:
        return formatDate(date);
    }
  }
}
