import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youandi_diary/user/model/user_model.dart';

final selectedMembersProvider =
    StateNotifierProvider<SelectedMembers, List<UserModel>>(
        (ref) => SelectedMembers());

class SelectedMembers extends StateNotifier<List<UserModel>> {
  UserModel? currentUser;
  SelectedMembers() : super([]);

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
}
