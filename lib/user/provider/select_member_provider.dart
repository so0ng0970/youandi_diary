import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youandi_diary/user/model/user_model.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final selectedMembersProvider =
    StateNotifierProvider<SelectedMembers, List<UserModel>>(
        (ref) => SelectedMembers(ref.container));

class SelectedMembers extends StateNotifier<List<UserModel>> {
  UserModel? currentUser;
  final ProviderContainer ref;

  SelectedMembers(this.ref) : super([]) {
    _loadInitialData();
  }

  void add(UserModel user) {
    state = [...state, user];
  }

  void remove(UserModel user) {
    state = state.where((element) => element.uid != user.uid).toList();
  }

  void reset() {
    // new method
    if (currentUser != null) {
      state = [currentUser!];
    } else {
      state = [];
    }
  }

  Future<void> _loadInitialData() async {
    Stream<UserModel?> userStream = getUserStream();

    // Listen to the stream and update the current user when a new value is received.
    await for (UserModel? userModel in userStream) {
      if (userModel != null) {
        currentUser = userModel;

        if (!state.contains(currentUser!)) {
          add(currentUser!);
        }
      }
    }
  }

  Stream<UserModel?> getUserStream() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Stream.value(null);
    }

    return FirebaseFirestore.instance
        .collection('user')
        .doc(currentUser.uid)
        .snapshots()
        .map((snapshot) {
      Map<String, dynamic>? dataMap = snapshot.data();

      if (dataMap == null) {
        return null;
      } else {
        return UserModel.fromJson(dataMap);
      }
    });
  }
}
