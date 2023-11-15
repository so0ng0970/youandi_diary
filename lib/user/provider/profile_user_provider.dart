import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/user_model.dart';

final userDataProvider = Provider(
    (ref) => UserDataProvider(FirebaseFirestore.instance.collection('user')));

final userGetProvider = StreamProvider<UserModel?>((ref) async* {
  yield* ref.watch(userDataProvider).getUserStream();
});

final userUpdateProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, userData) async {
  return ref
      .watch(userDataProvider)
      .updateUser(userData['uid'], userData['userName'], userData['photoUrl']);
});

class UserDataProvider {
  final CollectionReference userReference;
  User? currentUser = FirebaseAuth.instance.currentUser;
  UserDataProvider(this.userReference);

  Stream<UserModel?> getUserStream() {
    return FirebaseAuth.instance.authStateChanges().asyncMap((user) {
      if (user != null) {
        return userReference.doc(user.uid).get().then((snapshot) =>
            UserModel.fromJson(snapshot.data() as Map<String, dynamic>));
      } else {
        print("로그인하지 않은 사용자는 사용자 정보를 가져올 수 없습니다.");
        return null;
      }
    });
  }

  Future<void> updateUser(
      String uid, String displayName, String photoUrl) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await userReference.doc(uid).update({
        'photoUrl': photoUrl,
        'userName': displayName,
      });

      QuerySnapshot userPostsSnapshot =
          await firestore.collection('user').doc(uid).collection('post').get();

      for (DocumentSnapshot postDoc in userPostsSnapshot.docs) {
        postDoc.reference.update({
          'userName': displayName,
          'photoUrl': photoUrl,
        });
      }

      QuerySnapshot diaryDocsSnapshot =
          await firestore.collection('diary').get();
      for (DocumentSnapshot diaryDoc in diaryDocsSnapshot.docs) {
        List<UserModel> members = List<UserModel>.from(
            diaryDoc['member'].map((m) => UserModel.fromJson(m)));

        for (UserModel member in members) {
          if (member.uid == uid) {
            member.userName = displayName;
          }
        }

        diaryDoc.reference.update({
          'member': members.map((m) => m.toJson()).toList(),
        });
      }
      for (DocumentSnapshot diaryDoc in diaryDocsSnapshot.docs) {
        QuerySnapshot postDocsSnapshot = await diaryDoc.reference
            .collection('post')
            .where('userId', isEqualTo: uid)
            .get();

        for (DocumentSnapshot postDoc in postDocsSnapshot.docs) {
          postDoc.reference.update({
            'userName': displayName,
            'photoUrl': photoUrl,
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
