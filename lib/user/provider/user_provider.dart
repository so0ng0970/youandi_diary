import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youandi_diary/common/const/data.dart';
import 'package:youandi_diary/user/model/user_model.dart';
import 'package:youandi_diary/user/provider/firebase_auth_provider.dart';

final userProvider = ChangeNotifierProvider<UserProvider>((ref) {
  final firebaseAuth = ref.watch(firebase_auth_Provider);
  final currentEmail = firebaseAuth.maybeWhen(
    data: (user) => user?.email ?? '',
    orElse: () => '',
  );

  return UserProvider(
      FirebaseFirestore.instance.collection(
        'user',
      ),
      currentEmail);
});

class UserProvider with ChangeNotifier {
  bool _disposed = false;

  CollectionReference userReference;
  List<UserModel> users = [];
  List<UserModel> searchUser = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserProvider(this.userReference, currentEmail) {
    fetchUser(currentEmail);
  }
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  Future<void> fetchUser(String currentEmail) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      users = await userReference.get().then((QuerySnapshot results) {
        return results.docs
            .map((DocumentSnapshot document) {
              return UserModel.fromJson(
                  document.data() as Map<String, dynamic>);
            })
            .where((user) => user.email != currentEmail)
            .toList();
      });
      searchUser = users;
      notifyListeners();
    } else {
      print("로그인하지 않은 사용자는 사용자 정보를 가져올 수 없습니다.");
    }
  }

  void search(String query) {
    searchUser = [];

    if (query.isEmpty) {
      return;
    }

    for (UserModel user in users) {
      if (user.email!.toLowerCase().startsWith(query.toLowerCase())) {
        searchUser.add(user);
      }
    }
    notifyListeners();
  }

  void clearSearch() {
    searchUser = [];
    notifyListeners();
  }

  void resetSearch() {
    searchUser = users;
    for (var user in users) {
      user.isChecked = false;
    }
  }
}

// 사용자 프로필 사진
ImageProvider selectImage({String? imageUrl}) {
  if (imageUrl != null &&
      (imageUrl.startsWith('http') || imageUrl.startsWith('https'))) {
    return NetworkImage(imageUrl);
  } else {
    return const AssetImage(
      BASIC_PROFILE_URL,
    );
  }
}
