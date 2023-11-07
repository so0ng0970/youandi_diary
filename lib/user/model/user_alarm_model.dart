// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'user_alarm_model.g.dart';

@JsonSerializable()
class UserAlarmModel {
  late String? alarmId;
  late String? userId;
  late String? myId;
  final String? diaryId;
  late String? postId;
  late String? commentId;
  final String? diaryTittle;
  final String? postTittle;
  final String? userName;
  final String? alarmContent;
  bool? isChecked;

  UserAlarmModel({
    this.alarmId,
    this.userId,
    this.myId,
    this.diaryId,
    this.postId,
    this.commentId,
    this.diaryTittle,
    this.postTittle,
    this.userName,
    this.alarmContent,
    this.isChecked,
  });

  factory UserAlarmModel.fromJson(Map<String, dynamic> json) =>
      _$UserAlarmModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserAlarmModelToJson(this);
}
