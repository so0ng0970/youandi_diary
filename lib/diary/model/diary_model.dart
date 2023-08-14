import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youandi_diary/user/model/user_model.dart';

part 'diary_model.g.dart';

@JsonSerializable()
class DiaryModel {
  late String? diaryId;
  late String title;
  late String coverImg;
  @JsonKey(fromJson: _fromJsonTimestamp, toJson: _toJsonTimestamp)
  late DateTime dataTime;
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

  // Firestore에서 'dataTime' 필드를 DateTime으로 변환하는 함수 추가
  static DateTime _fromJsonTimestamp(Timestamp timestamp) =>
      timestamp.toDate();

  // 변환된 'dataTime'을 Timestamp로 다시 변환하는 함수 추가
  static Timestamp _toJsonTimestamp(DateTime dateTime) =>
      Timestamp.fromDate(dateTime);
}
