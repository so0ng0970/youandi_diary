// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryModel _$DiaryModelFromJson(Map<String, dynamic> json) => DiaryModel(
      diaryId: json['diaryId'] as String?,
      title: json['title'] as String,
      dataTime: DiaryModel._fromJsonTimestamp(json['dataTime'] as Timestamp),
      coverImg: json['coverImg'] as String,
      member: (json['member'] as List<dynamic>)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DiaryModelToJson(DiaryModel instance) =>
    <String, dynamic>{
      'diaryId': instance.diaryId,
      'title': instance.title,
      'coverImg': instance.coverImg,
      'dataTime': DiaryModel._toJsonTimestamp(instance.dataTime),
      'member': instance.member,
    };
