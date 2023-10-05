// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youandi_diary/common/utils/data_utils.dart';
import 'package:youandi_diary/diary/model/diary_comment_model.dart';

import 'package:youandi_diary/diary/provider/diart_detail_provider.dart';
import 'package:youandi_diary/user/provider/user_provider.dart';

import '../../common/const/color.dart';
import '../layout/button_dialog_layout.dart';

class DiaryCommentCard extends ConsumerStatefulWidget {
  String userId;
  Color divColor;
  String photoUrl;
  TextEditingController contentController;
  VoidCallback sendOnpress;
  String? comment;
  String? postId;
  DiaryCommentCard({
    Key? key,
    required this.userId,
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
    );
  }
}

String? editCommentId;

class _DiaryCommentCardState extends ConsumerState<DiaryCommentCard> {
  @override
  void initState() {
    super.initState();
    initializeComment();
  }

  bool edit = false;
  TextEditingController editingController = TextEditingController();
  Future<void> initializeComment() async {
    if (edit == true && editCommentId != null) {
      List<DiaryCommentModel> existingComments = await ref
          .read(diaryDetailProvider.notifier)
          .getCommentListFromFirestore(editCommentId.toString())
          .first;
      DiaryCommentModel existingDiaryComment = existingComments
          .firstWhere((comment) => comment.commentId == editCommentId);
      print('$editCommentId d, $existingComments');
      editingController.text = existingDiaryComment.content.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final getCommentList = ref.watch(
      getCommentListProvider(
        widget.postId.toString(),
      ),
    );
    final commentProvider = ref.watch(diaryDetailProvider.notifier);
    final userData = ref.watch(userDataProvider);

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
                            child: Image.network(
                              data.photoUrl.toString(),
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
                          return SizedBox(
                            height: 25,
                            width: 50,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                              child: Row(
                                children: [
                                  Text(
                                      '${commentData.userName.toString()} :  '),
                                  if (editCommentId != commentData.commentId)
                                    Text(
                                      commentData.content.toString(),
                                    ),
                                  if (editCommentId == commentData.commentId)
                                    SizedBox(
                                        height: 20,
                                        width: 100,
                                        child:
                                            textFormField(editingController)),
                                  const Spacer(),
                                  if (DataUtils().uid == commentData.userId)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          edit = true;
                                          editCommentId = commentData.commentId;

                                          print(editCommentId);
                                        });
                                      },
                                      child: const Icon(
                                        Icons.mode_edit_outline,
                                        size: 15,
                                      ),
                                    ),
                                  if (DataUtils().uid == commentData.userId)
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return ButtonDialogLayout(
                                              onPressed: () {
                                                commentProvider
                                                    .deleteCommentFromFirestore(
                                                  commentData.commentId
                                                      .toString(),
                                                );
                                                context.pop();
                                              },
                                              text: '정말 삭제하시겠습니까?',
                                            );
                                          },
                                        );
                                      },
                                      child: const Icon(
                                        Icons.delete_forever_outlined,
                                        size: 15,
                                        color: DELETE_BUTTON,
                                      ),
                                    ),
                                ],
                              ),
                            ),
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
