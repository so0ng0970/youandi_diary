// models/model_item.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String id;
  late String email;
  late String photoUrl;
  late String userName;
  bool? isChecked = false;

  UserModel({
    required this.id,
    required this.photoUrl,
    required this.email,
    required this.userName,
    this.isChecked,
  });

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    id = snapshot.id;
    photoUrl = data['photoUrl'];
    email = data['email'] ?? '';
    userName = data['userName'] ?? '';
  }
}
