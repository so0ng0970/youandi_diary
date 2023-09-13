import 'package:flutter/material.dart';
import 'package:youandi_diary/diary/model/diary_post_model.dart';

class DiaryDetailCard extends StatelessWidget {
  final String? diaryId;
  late String? postId;
  final String title;
  final String content;
  late String? photoUrl;
  late String? userName;
  final String? videoUrl;
  final List<String>? imgUrl;

  late DateTime dataTime;
  DiaryDetailCard({
    Key? key,
    this.diaryId,
    this.postId,
    required this.title,
    required this.content,
    this.photoUrl,
    this.userName,
    this.videoUrl,
    this.imgUrl,
    required this.dataTime,
  }) : super(key: key);
  factory DiaryDetailCard.fromModel({
    required DiaryPostModel diaryData,
  }) {
    return DiaryDetailCard(
      diaryId: diaryData.diaryId,
      postId: diaryData.postId,
      title: diaryData.title.toString(),
      content: diaryData.content.toString(),
      videoUrl: diaryData.videoUrl,
      imgUrl: diaryData.imgUrl,
      photoUrl: diaryData.photoUrl,
      dataTime: diaryData.dataTime,
      userName: diaryData.userName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(title),
    );
  }
}
