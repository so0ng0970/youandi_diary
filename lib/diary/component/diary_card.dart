// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youandi_diary/common/const/color.dart';
import 'package:youandi_diary/common/utils/data_utils.dart';
import 'package:youandi_diary/diary/model/diary_model.dart';
import 'package:youandi_diary/user/model/user_model.dart';

class DiaryCard extends StatelessWidget {
  final String? diaryId;
  final String title;
  final String coverImg;
  final DateTime dataTime;
  final List<UserModel> member;
  const DiaryCard({
    Key? key,
    this.diaryId,
    required this.title,
    required this.coverImg,
    required this.dataTime,
    required this.member,
  }) : super(key: key);
  factory DiaryCard.fromModel({
    required DiaryModel diaryList,
  }) {
    return DiaryCard(
        diaryId: diaryList.diaryId,
        title: diaryList.title,
        coverImg: diaryList.coverImg,
        dataTime: diaryList.dataTime,
        member: diaryList.member);
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/detail/$diaryId', extra: {
          'title': title,
        });
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              coverImg,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 30,
                  color: WHITE_COLOR,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                '작성자: ${member.map((e) => e.userName).toList().join(',')}',
                style: const TextStyle(
                  fontSize: 15,
                  color: WHITE_COLOR,
                ),
              ),
              const Spacer(),
              Center(
                child: Text(
                  DataUtils.getTimeFromDateTime(dateTime: dataTime).toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    color: WHITE_COLOR,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 
}
