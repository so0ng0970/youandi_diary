// UserProvider 변경
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youandi_diary/user/model/user_model.dart';

final userProvider = ChangeNotifierProvider.autoDispose<UserProvider>((ref) {
  return UserProvider(FirebaseFirestore.instance.collection('user'));
});

class UserProvider with ChangeNotifier {
  CollectionReference userReference;
  List<UserModel> users = [];
  List<UserModel> searchUser = [];

  UserProvider(this.userReference) {
    fetchUser();
  }

  Future<void> fetchUser() async {
    users = await userReference.get().then((QuerySnapshot results) {
      return results.docs.map((DocumentSnapshot document) {
        return UserModel.fromSnapshot(document);
      }).toList();
    });
    searchUser = users;
    notifyListeners();
  }

  void search(String query) {
    searchUser = [];

    if (query.isEmpty) {
      return;
    }

    for (UserModel user in users) {
      if (user.email.toLowerCase().startsWith(query.toLowerCase())) {
        searchUser.add(user);
      }
    }
    notifyListeners();
  }

  void clearSearch() {
    searchUser = [];
    notifyListeners();
  }
}
