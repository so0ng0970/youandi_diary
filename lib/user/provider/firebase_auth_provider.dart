import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youandi_diary/user/model/user_model.dart';

final firebase_auth_Provider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
final userInfoProvider = StreamProvider<UserModel>((ref) async* {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // 현재 사용자의 uid 가져오기
  final String? currentUserId = auth.currentUser?.uid;

  if (currentUserId != null) {
    final DocumentSnapshot userSnapshot =
        await firestore.collection('user').doc(currentUserId).get();
    final Map<String, dynamic>? userData =
        userSnapshot.data() as Map<String, dynamic>?;

    if (userData != null) {
      final UserModel currentUser = UserModel(
        photoUrl: userData['photoUrl'],
        userName: userData['userName'],
        email: userData['email'],
        uid: userData['uid'],
      );
      yield currentUser;
    } else {
      yield null as UserModel; // 현재 사용자 정보 없음을 나타내는 UserModel 인스턴스 반환
    }
  }
});
