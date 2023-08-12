class DataUtils {
  static String getTimeFromDateTime({required DateTime dateTime}) {
    return '${dateTime.year}-${getTimeFormat(dateTime.month)}-${getTimeFormat(dateTime.day)}';
  }

  static String getTimeFormat(int number) {
    return number.toString().padLeft(2, '0');
  }
}
