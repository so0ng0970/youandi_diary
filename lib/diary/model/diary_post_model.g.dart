// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryPostModel _$DiaryPostModelFromJson(Map<String, dynamic> json) =>
    DiaryPostModel(
      diaryId: json['diaryId'] as String?,
      postId: json['postId'] as String?,
      title: json['title'] as String,
      content: json['content'] as String,
      photoUrl: json['photoUrl'] as String?,
      userName: json['userName'] as String?,
      videoUrl: json['videoUrl'] as String?,
      imgUrl:
          (json['imgUrl'] as List<dynamic>?)?.map((e) => e as String).toList(),
      dataTime:
          DiaryPostModel._fromJsonTimestamp(json['dataTime'] as Timestamp),
    );

Map<String, dynamic> _$DiaryPostModelToJson(DiaryPostModel instance) =>
    <String, dynamic>{
      'diaryId': instance.diaryId,
      'postId': instance.postId,
      'title': instance.title,
      'content': instance.content,
      'photoUrl': instance.photoUrl,
      'userName': instance.userName,
      'videoUrl': instance.videoUrl,
      'imgUrl': instance.imgUrl,
      'dataTime': DiaryPostModel._toJsonTimestamp(instance.dataTime),
    };
