import 'package:firebase_auth/firebase_auth.dart';

class DataUtils {
  static String getTimeFromDateTime({required DateTime dateTime}) {
    return '${dateTime.year}-${getTimeFormat(dateTime.month)}-${getTimeFormat(dateTime.day)}';
  }

  static String getTimeFormat(int number) {
    return number.toString().padLeft(2, '0');
  }

  User? get currentUser => FirebaseAuth.instance.currentUser;

  String get uid => currentUser?.uid ?? '';
}
