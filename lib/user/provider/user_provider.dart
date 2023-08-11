// UserProvider 변경
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youandi_diary/common/const/data.dart';
import 'package:youandi_diary/user/model/user_model.dart';
import 'package:youandi_diary/user/provider/firebase_auth_provider.dart';

final userProvider = ChangeNotifierProvider.autoDispose<UserProvider>((ref) {
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
  CollectionReference userReference;
  List<UserModel> users = [];
  List<UserModel> searchUser = [];

  UserProvider(this.userReference, currentEmail) {
    fetchUser(currentEmail);
  }

  Future<void> fetchUser(String currentEmail) async {
    users = await userReference.get().then((QuerySnapshot results) {
      return results.docs
          .map((DocumentSnapshot document) {
            return UserModel.fromJson(document.data() as Map<String, dynamic>);
          })
          .where((user) => user.email != currentEmail)
          .toList();
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

// 사용자 프로필 사진
ImageProvider selectImage({String? imageUrl}) {
  if (imageUrl != null &&
      (imageUrl.startsWith('http') || imageUrl.startsWith('https'))) {
    return NetworkImage(imageUrl);
  } else if (imageUrl != null && imageUrl.startsWith('asset')) {
    return AssetImage(imageUrl);
  } else {
    return const AssetImage(
      BASIC_PROFILE_URL,
    );
  }
}
