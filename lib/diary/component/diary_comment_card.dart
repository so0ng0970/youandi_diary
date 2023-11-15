// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import 'package:youandi_diary/diary/component/diary_comment_list.dart';
import 'package:youandi_diary/diary/model/diary_comment_model.dart';
import 'package:youandi_diary/user/component/profile_component.dart';

import '../../common/const/color.dart';
import '../../user/model/user_alarm_model.dart';
import '../../user/model/validate.dart';
import '../../user/provider/profile_user_provider.dart';
import '../provider/diary_comment_provider.dart';

class DiaryCommentCard extends ConsumerStatefulWidget {
  String userId;
  String diaryId;
  Color divColor;
  String photoUrl;
  String? comment;
  String? postId;
  bool? postListbool;

  String userName;

  DiaryCommentCard({
    Key? key,
    required this.userId,
    required this.diaryId,
    required this.divColor,
    required this.photoUrl,
    this.comment,
    this.postId,
    this.postListbool,
    required this.userName,
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
      comment: comment ?? this.comment,
      postId: postId ?? this.postId,
      diaryId: diaryId ?? this.diaryId,
      userName: '',
    );
  }
}

class _DiaryCommentCardState extends ConsumerState<DiaryCommentCard> {
  @override
  void initState() {
    super.initState();
    contentController = TextEditingController();
  }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  late TextEditingController contentController;
  FocusNode contentFocus = FocusNode();
  DateTime dateTime = DateTime.now();
  String? editCommentId;
  final bool _isError = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        focusNode: contentFocus,
        validator: (value) => CheckValidate().validatelength(
          focusNode: contentFocus,
          title: '댓글',
          value: value!,
        ),
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
                      width: widget.postListbool == true
                          ? MediaQuery.of(context).size.width - 130
                          : MediaQuery.of(context).size.width - 173,
                      child: Form(
                        key: _formKey,
                        child: textFormField(contentController),
                      ),
                    ),
                  ),
                  if (contentController.text.trim().isNotEmpty ||
                      widget.postListbool == true)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            ref.watch(userGetProvider).when(
                                  data: (data) async {
                                    String content = contentController.text;
                                    DiaryCommentModel commentPost =
                                        DiaryCommentModel(
                                      diaryId: widget.diaryId,
                                      dataTime: dateTime,
                                      postId: widget.postId,
                                      content: content,
                                    );
                                    UserAlarmModel alarmPost = UserAlarmModel(
                                      alarmContent: content,
                                      diaryId: widget.diaryId,
                                      postId: widget.postId,
                                      userName: data?.userName,
                                      myId: widget.userId,
                                    );
                                    setState(() {
                                      ref
                                          .watch(diaryCommentProvider.notifier)
                                          .saveCommentToFirestore(
                                            userId: widget.userId.toString(),
                                            diaryId: widget.diaryId.toString(),
                                            model: commentPost,
                                            postId:
                                                commentPost.postId.toString(),
                                            alarmModel: alarmPost,
                                          );
                                    });
                                    HttpsCallable callable = FirebaseFunctions
                                        .instance
                                        .httpsCallable('addMessage');
                                    try {
                                      final HttpsCallableResult result =
                                          await callable.call(<String, dynamic>{
                                        'diaryId': widget.diaryId.toString(),
                                        'postId': widget.postId.toString(),
                                        'commentId':
                                            commentPost.commentId.toString(),
                                      });
                                    } on FirebaseFunctionsException {}

                                    contentController.clear();
                                  },
                                  loading: () => const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.amber,
                                    ),
                                  ),
                                  error: (error, stackTrace) => const Text(
                                    '데이터를 불러오지 못했습니다',
                                  ),
                                );
                          }
                        },
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
                            contentController: contentController,
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
