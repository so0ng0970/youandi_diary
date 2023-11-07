import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:youandi_diary/diary/component/diary_detail_card.dart';
import 'package:youandi_diary/diary/layout/button_dialog_layout.dart';
import 'package:youandi_diary/diary/model/diary_post_model.dart';
import 'package:youandi_diary/diary/provider/diart_detail_provider.dart';
import 'package:youandi_diary/diary/screen/diary_post_screen.dart';
import 'package:youandi_diary/user/provider/user_alarm_provider.dart';

import '../../common/const/color.dart';
import '../model/user_alarm_model.dart';

class AlarmList extends ConsumerStatefulWidget {
  const AlarmList({super.key});

  @override
  ConsumerState<AlarmList> createState() => _AlarmListState();
}

class _AlarmListState extends ConsumerState<AlarmList> {
  late FocusNode inputFieldNode;
  @override
  void initState() {
    super.initState();
    inputFieldNode = FocusNode();
  }

  @override
  void dispose() {
    inputFieldNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alarmProvider = ref.watch(userAlarmProvider.notifier);
    final diaryProvider = ref.watch(diaryDetailProvider.notifier);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 300,
          height: 450,
          child: StreamBuilder<List<UserAlarmModel>>(
            stream: alarmProvider.getAlarmListFromFirestore(),
            builder: (BuildContext context,
                AsyncSnapshot<List<UserAlarmModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<UserAlarmModel> alarmList = snapshot.data ?? [];

                return ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    UserAlarmModel alarm = alarmList[index];
                    final post = diaryProvider.getDiaryListFromFirestore(
                      alarm.diaryId.toString(),
                      DateTime.now(),
                    );
                    return StreamBuilder<List<DiaryPostModel>>(
                      stream: diaryProvider.getDiaryListFromFirestore(
                        alarm.diaryId.toString(),
                        DateTime.now(),
                      ),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<DiaryPostModel>> diary) {
                        if (diary.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (diary.hasError) {
                          return Text('Error: ${diary.error}');
                        } else {
                          List<DiaryPostModel>? diaryDataList = diary.data;
                          DiaryPostModel? diaryData;

                          if (diaryDataList != null) {
                            diaryData = diaryDataList.firstWhere(
                              (post) => post.postId == alarm.postId,
                            );
                          }
                          return ClipRect(
                            child: Slidable(
                              key: const ValueKey(0),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ButtonDialogLayout(
                                              onPressed: () async {
                                                context.pop();
                                                alarmProvider
                                                    .deleteAlarmFromFirestore(
                                                  alarmId:
                                                      alarm.alarmId.toString(),
                                                );
                                              },
                                              text: '정말 삭제하시겠습니까?');
                                        },
                                      );
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: '삭제',
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return Scaffold(
                                        backgroundColor: TWOCOLOR,
                                        extendBodyBehindAppBar: true,
                                        appBar: AppBar(
                                          centerTitle: true,
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          title: Text(
                                            alarm.diaryTittle ?? '',
                                          ),
                                        ),
                                        body: SafeArea(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 0, 8, 15),
                                            child: DiaryDetailCard.fromModel(
                                              postListbool: true,
                                              editOnPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DiaryPostScreen(
                                                      postId: alarm.postId,
                                                      diaryId: alarm.diaryId
                                                          .toString(),
                                                      edit: true,
                                                      diaryTitle: alarm
                                                          .diaryTittle
                                                          .toString(),
                                                      selectedDay:
                                                          DateTime.now(),
                                                    ),
                                                  ),
                                                );
                                              },
                                              deleteOnpress: () {
                                                setState(() {
                                                  ref
                                                      .watch(diaryDetailProvider
                                                          .notifier)
                                                      .deletePostFromFirestore(
                                                        diaryId: alarm.diaryId
                                                            .toString(),
                                                        postId: alarm.postId
                                                            .toString(),
                                                      );

                                                  context.pop();
                                                });
                                                context.pop();
                                              },
                                              diaryData: diaryData!,
                                              color: ONECOLOR,
                                              divColor: DIVONE,
                                              inputFieldNode: inputFieldNode,
                                              contentController: null,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ));
                                  setState(() {});
                                },
                                child: SizedBox(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (alarmList.isNotEmpty)
                                        Text(
                                          '${alarm.userName}이 "${alarm.alarmContent!.length > 8 ? '${alarm.alarmContent!.substring(0, 8)}...' : alarm.alarmContent}"댓글을 남겼습니다',
                                        ),
                                      if (alarmList.isEmpty)
                                        const Text(
                                          '알림이 없습니다',
                                          style: TextStyle(
                                            color: Colors.black12,
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                  itemCount: alarmList.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
