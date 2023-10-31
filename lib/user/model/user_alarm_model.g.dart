// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_alarm_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAlarmModel _$UserAlarmModelFromJson(Map<String, dynamic> json) =>
    UserAlarmModel(
      alarmId: json['alarmId'] as String?,
      userId: json['userId'] as String?,
      myId: json['myId'] as String?,
      diaryId: json['diaryId'] as String?,
      postId: json['postId'] as String?,
      commentId: json['commentId'] as String?,
      diaryTittle: json['diaryTittle'] as String?,
      postTittle: json['postTittle'] as String?,
      userName: json['userName'] as String?,
      alarmContent: json['alarmContent'] as String?,
      isChecked: json['isChecked'] as bool?,
    );

Map<String, dynamic> _$UserAlarmModelToJson(UserAlarmModel instance) =>
    <String, dynamic>{
      'alarmId': instance.alarmId,
      'userId': instance.userId,
      'myId': instance.myId,
      'diaryId': instance.diaryId,
      'postId': instance.postId,
      'commentId': instance.commentId,
      'diaryTittle': instance.diaryTittle,
      'postTittle': instance.postTittle,
      'userName': instance.userName,
      'alarmContent': instance.alarmContent,
      'isChecked': instance.isChecked,
    };
