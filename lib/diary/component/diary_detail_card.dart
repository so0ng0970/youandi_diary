// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:youandi_diary/common/const/color.dart';
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
  final Color divColor;

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
    required this.color,
    required this.divColor,
    required this.dataTime,
  }) : super(key: key);
  factory DiaryDetailCard.fromModel(
      {required DiaryPostModel diaryData, required color, required divColor}) {
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
      divColor: divColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
      child: Container(
        height: 450,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: divColor,
            width: 2,
          ),
        ),
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
                Padding(
                  padding: const EdgeInsets.only(
                    right: 5,
                  ),
                  child: Text(
                    userName.toString(),
                  ),
                ),
              ],
            ),
            Divider(color: divColor),
            if (imgUrl!.isNotEmpty)
              SizedBox(
                height: 150,
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
            const SizedBox(
              height: 5,
            ),
            if (videoUrl != null) CustomVideoPlayer(videoUrl: videoUrl),
            Text(
              content,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            const Spacer(),
            Center(
              child: Text(
                DataUtils.getTimeFromDateTime(
                  dateTime: dataTime,
                ),
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            _Comment(
              photoUrl: photoUrl.toString(),
              divColor: divColor,
            )
          ],
        ),
      ),
    );
  }
}

class _Comment extends StatelessWidget {
  Color divColor;
  String photoUrl;
  _Comment({
    Key? key,
    required this.divColor,
    required this.photoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: WHITE_COLOR,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                child: Row(
                  children: [
                    Container(
                      height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: divColor,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(photoUrl),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Form(
                      child: SizedBox(
                        height: 25,
                        width: MediaQuery.of(context).size.width - 148,
                        child: TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: divColor,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
