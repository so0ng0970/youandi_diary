// models/model_item.dart
import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  late String? id;
  late String email;
  late String photoUrl;
  late String userName;
  late bool? isChecked;

  UserModel({
    this.id,
    required this.photoUrl,
    required this.email,
    required this.userName,
    this.isChecked = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // 현재 인스턴스를 변환 ,json 으로 instance 변환 하는 것
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
