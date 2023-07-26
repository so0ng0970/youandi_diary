import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firebase_auth_Provider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
