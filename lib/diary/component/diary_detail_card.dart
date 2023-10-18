// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youandi_diary/diary/component/custom_video_player.dart';
import 'package:youandi_diary/diary/component/diary_comment_card.dart';

import 'package:youandi_diary/diary/model/diary_post_model.dart';
import 'package:youandi_diary/user/component/profile_component.dart';

import '../../common/const/color.dart';
import '../../common/utils/data_utils.dart';
import '../../user/provider/user_provider.dart';
import '../layout/button_dialog_layout.dart';

class DiaryDetailCard extends ConsumerStatefulWidget {
  final String? userId;
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
  final VoidCallback deleteOnpress;
  final VoidCallback editOnPressed;
  late DateTime dataTime;
  late FocusNode inputFieldNode;
  final TextEditingController contentController;
  final VoidCallback sendOnpress;
  bool? postListbool;

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
    this.postListbool,
    required this.color,
    required this.divColor,
    required this.deleteOnpress,
    required this.editOnPressed,
    required this.dataTime,
    required this.inputFieldNode,
    required this.contentController,
    required this.sendOnpress,
    this.userId,
  }) : super(key: key);
  factory DiaryDetailCard.fromModel({
    required DiaryPostModel diaryData,
    required color,
    required divColor,
    required deleteOnpress,
    required editOnPressed,
    required sendOnpress,
    required inputFieldNode,
    required contentController,
    postListbool,
  }) {
    return DiaryDetailCard(
      userId: diaryData.userId,
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
      deleteOnpress: deleteOnpress,
      editOnPressed: editOnPressed,
      inputFieldNode: inputFieldNode,
      contentController: contentController,
      sendOnpress: sendOnpress,
      postListbool: postListbool,
    );
  }

  @override
  ConsumerState<DiaryDetailCard> createState() => _DiaryDetailCardState();
}

class _DiaryDetailCardState extends ConsumerState<DiaryDetailCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
      child: Container(
        height: widget.postListbool == true
            ? MediaQuery.of(context).size.height
            : 450,
        decoration: BoxDecoration(
          color: widget.color,
          border: Border.all(
            color: widget.divColor,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Row(
                  children: [
                    if (DataUtils().uid == widget.userId)
                      GestureDetector(
                        onTap: widget.editOnPressed,
                        child: const Icon(
                          Icons.mode_edit_outline,
                          size: 20,
                        ),
                      ),
                    const SizedBox(
                      width: 5,
                    ),
                    if (DataUtils().uid == widget.userId)
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return ButtonDialogLayout(
                                onPressed: widget.deleteOnpress,
                                text: '정말 삭제하시겠습니까?',
                              );
                            },
                          );
                        },
                        child: const Icon(
                          Icons.delete_forever_outlined,
                          size: 20,
                          color: DELETE_BUTTON,
                        ),
                      ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                    width: 30,
                    height: 30,
                    child: ClipOval(
                      child: Image(
                        image: selectImage(imageUrl: widget.photoUrl),
                        fit: BoxFit.cover,
                      ),
                    )),
                const SizedBox(
                  width: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 5,
                  ),
                  child: Text(
                    widget.userName.toString(),
                  ),
                ),
              ],
            ),
            Divider(color: widget.divColor),
            if (widget.imgUrl != null && widget.imgUrl!.isNotEmpty)
              SizedBox(
                height: 150,
                child: PageView.builder(
                  itemCount: widget.imgUrl?.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Center(
                          child: ProfileComponent(
                            imgUrl: widget.imgUrl![index],
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
            if (widget.videoUrl != null)
              CustomVideoPlayer(videoUrl: widget.videoUrl),
            Text(
              widget.content,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            const Spacer(),
            Center(
              child: Text(
                DataUtils.getTimeFromDateTime(
                  dateTime: widget.dataTime,
                ),
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            DiaryCommentCard(
                diaryId: widget.diaryId.toString(),
                userId: widget.userId.toString(),
                postId: widget.postId,
                photoUrl: widget.photoUrl.toString(),
                divColor: widget.divColor,
                sendOnpress: widget.sendOnpress,
                contentController: widget.contentController,
                postListbool: widget.postListbool)
          ],
        ),
      ),
    );
  }
}
