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
    final user = ref.read(firebaseAuthProvider).currentUser;
    if (user != null) {
      String userName = user.displayName ?? '';
      String userEmail = user.email ?? '이메일 없음';
      String userPhotoUrl = user.photoURL ?? '';
      String userId = user.uid;

      currentUser = UserModel(
        userName: userName,
        email: userEmail,
        photoUrl: userPhotoUrl,
        uid: userId,
      );

      if (currentUser != null) {
        state.add(currentUser!);
      }
    }
  }
}
