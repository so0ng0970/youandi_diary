// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:youandi_diary/diary/layout/button_dialog_layout.dart';
import 'package:youandi_diary/diary/model/diary_comment_model.dart';

import '../../common/const/color.dart';
import '../../common/utils/data_utils.dart';
import '../provider/diart_detail_provider.dart';

class DiaryCommentList extends ConsumerStatefulWidget {
  DiaryCommentModel commentData;
  String editCommentId;
  String postId;
  TextEditingController contentController;
  Function(TextEditingController) textFormField;
  DiaryCommentList({
    super.key,
    required this.commentData,
    required this.editCommentId,
    required this.postId,
    required this.contentController,
    required this.textFormField,
  });

  @override
  ConsumerState<DiaryCommentList> createState() => _DiaryCommentListState();
}

class _DiaryCommentListState extends ConsumerState<DiaryCommentList> {
  bool edit = false;

  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      width: 50,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
        child: Row(
          children: [
            Text('${widget.commentData.userName.toString()} :  '),
            if (!edit)
              Text(
                widget.commentData.content.toString(),
              ),
            if (edit)
              Expanded(
                child: SizedBox(
                  height: 20,
                  child: widget.textFormField(editingController),
                ),
              ),
            const Spacer(),
            if (DataUtils().uid == widget.commentData.userId)
              Row(
                children: [
                  if (!edit)
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          widget.editCommentId =
                              widget.commentData.commentId.toString();
                          editingController.text =
                              widget.commentData.content.toString();
                          edit = true;
                        });
                        // await initializeComment();
                      },
                      child: const Icon(
                        Icons.mode_edit_outline,
                        size: 15,
                      ),
                    ),
                  if (edit)
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          ref
                              .watch(diaryDetailProvider.notifier)
                              .updateCommentInFirestore(
                                  widget.commentData.commentId.toString(),
                                  editingController.text);
                          edit = false;
                        });
                      },
                      child: const Icon(
                        Icons.check,
                        size: 15,
                      ),
                    ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ButtonDialogLayout(
                            onPressed: () {
                              ref
                                  .watch(diaryDetailProvider.notifier)
                                  .deleteCommentFromFirestore(
                                    widget.commentData.commentId.toString(),
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
              )
          ],
        ),
      ),
    );
  }
}
