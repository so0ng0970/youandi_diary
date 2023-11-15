import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youandi_diary/user/model/user_model.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final selectedMembersProvider =
    StateNotifierProvider<SelectedMembers, List<UserModel?>>(
        (ref) => SelectedMembers(ref.container));

class SelectedMembers extends StateNotifier<List<UserModel>> {
  UserModel? currentUser;
  final ProviderContainer ref;
  StreamSubscription<UserModel?>? userSubscription;

  SelectedMembers(this.ref) : super([]) {
    _initialize();
  }

  void add(UserModel user) {
    state = [...state, user];
  }

  void remove(UserModel user) {
    state = state.where((element) => element.uid != user.uid).toList();
  }

  void reset() {
    if (currentUser != null) {
      state = [currentUser!];
    } else {
      state = [];
    }
  }

  Future<void> _initialize() async {
    currentUser = await _getCurrentUser();
    if (currentUser != null) {
      add(currentUser!);
    }

    userSubscription = getUserStream().listen(
      (UserModel? userModel) {
        if (userModel != null) {
          currentUser = userModel;

          // state 초기화
          state = [];

          add(currentUser!);
        }
      },
    );
  }

  Future<UserModel?> _getCurrentUser() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(firebaseUser.uid)
          .get();
      Map<String, dynamic>? dataMap = snapshot.data() as Map<String, dynamic>?;
      if (dataMap != null) {
        return UserModel.fromJson(dataMap);
      }
    }
    return null;
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

  Future<void> cleanUp() async {
    if (userSubscription == null) {
      print('userSubscription is null');
    } else {
      print('cancel function starts');
      await userSubscription?.cancel();
    }
  }
}
