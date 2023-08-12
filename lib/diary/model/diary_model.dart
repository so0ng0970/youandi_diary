import 'package:json_annotation/json_annotation.dart';
import 'package:youandi_diary/user/model/user_model.dart';

part 'diary_model.g.dart';

@JsonSerializable()
class DiaryModel {
  late String? diaryId;
  late String title;
  late String coverImg;
  late String dataTime;
  late List<UserModel> member;

  DiaryModel({
    this.diaryId,
    required this.title,
    required this.dataTime,
    required this.coverImg,
    required this.member,
  });

  factory DiaryModel.fromJson(Map<String, dynamic> json) =>
      _$DiaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$DiaryModelToJson(this);
}
