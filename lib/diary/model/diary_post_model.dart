// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'diary_post_model.g.dart';

@JsonSerializable()
class DiaryPostModel {
  final String? diaryId;
  late String? postId;
  final String? title;
  final String? content;
  late String? photoUrl;
  late String? userName;
  final String? videoUrl;
  final List<String>? imgUrl;
  @JsonKey(fromJson: _fromJsonTimestamp, toJson: _toJsonTimestamp)
  late DateTime dataTime;

  DiaryPostModel({
    this.diaryId,
    this.postId,
    this.title,
    this.content,
    this.photoUrl,
    this.userName,
    this.videoUrl,
    this.imgUrl,
    required this.dataTime,
  });

  factory DiaryPostModel.fromJson(Map<String, dynamic> json) =>
      _$DiaryPostModelFromJson(json);
  Map<String, dynamic> toJson() => _$DiaryPostModelToJson(this);

  static DateTime _fromJsonTimestamp(Timestamp timestamp) => timestamp.toDate();

  static Timestamp _toJsonTimestamp(DateTime dateTime) =>
      Timestamp.fromDate(dateTime);
}