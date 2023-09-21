// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryCommentModel _$DiaryCommentModelFromJson(Map<String, dynamic> json) =>
    DiaryCommentModel(
      userId: json['userId'] as String?,
      diaryId: json['diaryId'] as String?,
      postId: json['postId'] as String?,
      commentId: json['commentId'] as String?,
      content: json['content'] as String?,
      userName: json['userName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      dataTime:
          DiaryCommentModel._fromJsonTimestamp(json['dataTime'] as Timestamp),
    );

Map<String, dynamic> _$DiaryCommentModelToJson(DiaryCommentModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'diaryId': instance.diaryId,
      'postId': instance.postId,
      'commentId': instance.commentId,
      'content': instance.content,
      'userName': instance.userName,
      'photoUrl': instance.photoUrl,
      'dataTime': DiaryCommentModel._toJsonTimestamp(instance.dataTime),
    };
