// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'diary_comment_model.g.dart';

@JsonSerializable()
class DiaryCommentModel {
  final String? diaryId;
  late String? postId;
  late String? commentId;
  final String? content;
  late String? userName;
  late String? photoUrl;
  @JsonKey(fromJson: _fromJsonTimestamp, toJson: _toJsonTimestamp)
  late DateTime dataTime;

  DiaryCommentModel({
    this.diaryId,
    this.postId,
    this.commentId,
    this.content,
    this.userName,
    this.photoUrl,
    required this.dataTime,
  });

  factory DiaryCommentModel.fromJson(Map<String, dynamic> json) =>
      _$DiaryCommentModelFromJson(json);
  Map<String, dynamic> toJson() => _$DiaryCommentModelToJson(this);

  static DateTime _fromJsonTimestamp(Timestamp timestamp) => timestamp.toDate();

  static Timestamp _toJsonTimestamp(DateTime dateTime) =>
      Timestamp.fromDate(dateTime);
}
