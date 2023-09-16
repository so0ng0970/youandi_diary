import 'package:flutter/material.dart';
import 'package:youandi_diary/common/utils/data_utils.dart';
import 'package:youandi_diary/diary/component/custom_video_player.dart';
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
  final Color color;

  late DateTime dataTime;
  DiaryDetailCard({
    required this.color,
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
  factory DiaryDetailCard.fromModel(
      {required DiaryPostModel diaryData, required color}) {
    return DiaryDetailCard(
      color: color,
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
      child: Container(
        height: 400,
        color: color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 25,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: ClipOval(
                    child: Image.network(
                      photoUrl.toString(),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  userName.toString(),
                ),
              ],
            ),
            if (imgUrl!.isNotEmpty)
              SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: imgUrl?.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Center(
                          child: Image.network(
                            imgUrl![index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            if (videoUrl != null) CustomVideoPlayer(videoUrl: videoUrl),
            Text(
              content,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            const Spacer(),
            Text(
              DataUtils.getTimeFromDateTime(
                dateTime: dataTime,
              ),
            )
          ],
        ),
      ),
    );
  }
}
