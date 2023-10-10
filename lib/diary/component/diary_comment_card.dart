// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import 'package:youandi_diary/diary/component/diary_comment_list.dart';
import 'package:youandi_diary/diary/provider/diart_detail_provider.dart';
import 'package:youandi_diary/user/component/profile_component.dart';

import '../../common/const/color.dart';
import '../../user/provider/profile_user_provider.dart';

class DiaryCommentCard extends ConsumerStatefulWidget {
  String userId;
  String diaryId;
  Color divColor;
  String photoUrl;
  TextEditingController contentController;
  VoidCallback sendOnpress;
  String? comment;
  String? postId;
  DiaryCommentCard({
    Key? key,
    required this.userId,
    required this.diaryId,
    required this.divColor,
    required this.photoUrl,
    required this.contentController,
    required this.sendOnpress,
    this.comment,
    this.postId,
  }) : super(key: key);

  @override
  ConsumerState<DiaryCommentCard> createState() => _DiaryCommentCardState();

  DiaryCommentCard copyWith({
    String? userId,
    String? diaryId,
    Color? divColor,
    String? photoUrl,
    TextEditingController? contentController,
    VoidCallback? sendOnpress,
    String? comment,
    String? postId,
  }) {
    return DiaryCommentCard(
      userId: userId ?? this.userId,
      divColor: divColor ?? this.divColor,
      photoUrl: photoUrl ?? this.photoUrl,
      contentController: contentController ?? this.contentController,
      sendOnpress: sendOnpress ?? this.sendOnpress,
      comment: comment ?? this.comment,
      postId: postId ?? this.postId,
      diaryId: diaryId ?? this.diaryId,
    );
  }
}

String? editCommentId;

class _DiaryCommentCardState extends ConsumerState<DiaryCommentCard> {
  @override
  @override
  Widget build(BuildContext context) {
    final getCommentList = ref.watch(
      getCommentListProvider(Tuple2(widget.diaryId, widget.postId.toString())),
    );

    final userData = ref.watch(userGetProvider);

    OutlineInputBorder inputDecoration = OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        20,
      ),
      borderSide: const BorderSide(
        color: Colors.black,
      ),
    );
    TextFormField textFormField(TextEditingController controller) {
      return TextFormField(
        controller: controller,
        decoration: InputDecoration(
            filled: true,
            fillColor: widget.divColor,
            focusedBorder: inputDecoration,
            enabledBorder: inputDecoration),
      );
    }

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 10, 0, 5),
              child: Row(
                children: [
                  Container(
                    height: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.divColor,
                      ),
                    ),
                    child: userData.when(
                      data: (data) {
                        if (data != null) {
                          return ClipOval(
                            child: ProfileComponent(
                              imgUrl: data.photoUrl.toString(),
                              width: 20,
                            ),
                          );
                        } else {
                          const CircularProgressIndicator();
                        }
                        return null;
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const Text('데이터 정보를 불러오지 못했습니다 '),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Form(
                    child: SizedBox(
                      height: 25,
                      width: MediaQuery.of(context).size.width - 173,
                      child: textFormField(widget.contentController),
                    ),
                  ),
                  if (widget.contentController.text.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: GestureDetector(
                        onTap: widget.sendOnpress,
                        child: Icon(
                          Icons.send,
                          size: 20,
                          color: widget.divColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: SizedBox(
                height: 58,
                child: getCommentList.when(
                  data: (data) {
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final commentData = data[index];

                          return DiaryCommentList(
                            commentData: commentData,
                            editCommentId: editCommentId.toString(),
                            postId: widget.postId.toString(),
                            contentController: widget.contentController,
                            textFormField: textFormField,
                          );
                        });
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const Text('데이터 정보를 불러오지 못했습니다 '),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
