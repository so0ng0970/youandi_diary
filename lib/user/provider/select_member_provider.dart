import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youandi_diary/user/model/user_model.dart';
import 'package:youandi_diary/user/provider/profile_user_provider.dart';

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
    // ignore: deprecated_member_use
    final userStream = ref.read(userGetProvider.stream);

    userStream.listen((user) {
      if (user != null) {
        String userName = user.userName;
        String userEmail = user.email ?? '이메일 없음';
        String userPhotoUrl = user.photoUrl;
        String userId = user.uid.toString();

        currentUser = UserModel(
          userName: userName,
          email: userEmail,
          photoUrl: userPhotoUrl,
          uid: userId,
        );

        if (!state.contains(currentUser!)) {
          state.add(currentUser!);
        }
      }
    });
  }
}
