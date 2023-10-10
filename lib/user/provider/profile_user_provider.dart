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

  UserDataProvider(this.userReference);

  Stream<UserModel?> getUserStream() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Stream.value(null);
    }

    return userReference.doc(currentUser.uid).snapshots().map((snapshot) =>
        UserModel.fromJson(snapshot.data() as Map<String, dynamic>));
  }

  Future<void> updateUser(
      String uid, String displayName, String photoUrl) async {
    try {
      await userReference.doc(uid).update({
        'photoUrl': photoUrl,
        'userName': displayName,
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
