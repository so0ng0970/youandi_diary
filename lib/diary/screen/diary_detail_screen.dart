// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:youandi_diary/common/utils/data_utils.dart';
import 'package:youandi_diary/diary/component/diary_detail_card.dart';
import 'package:youandi_diary/diary/model/diary_comment_model.dart';
import 'package:youandi_diary/diary/provider/diart_detail_provider.dart';
import 'package:youandi_diary/diary/screen/diary_post_screen.dart';

import '../../common/const/color.dart';
import '../../user/layout/default_layout.dart';
import '../component/calendar.dart';

class DiaryDetailScreen extends ConsumerStatefulWidget {
  final String diaryId;
  final String? title;

  const DiaryDetailScreen({
    Key? key,
    required this.diaryId,
    this.title,
  }) : super(key: key);

  @override
  ConsumerState<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends ConsumerState<DiaryDetailScreen> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  late FocusNode inputFieldNode;
  final TextEditingController contentController = TextEditingController();
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
    final getPostList = ref.watch(getPostListProvider(
      widget.diaryId,
    ));
    final colors = [
      ONECOLOR,
      TWOCOLOR,
      THREECOLOR,
      FOURCOLOR,
      FIVECOLOR,
    ];
    final divColors = [
      DIVONE,
      DIVTWO,
      DIVTHR,
      DIVFOUR,
      DIVFIV,
    ];

    return DefaultLayout(
      title: widget.title.toString(),
      color: DIARY_DETAIL_COLOR,
      popOnPressed: () {
        context.pop();
      },
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 140,
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: -60,
                      top: -20,
                      child: Image.asset(
                        'assets/image/icon/cloud_icon.png',
                        scale: 5,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _showCalendarModal(
                          selectedDay,
                          focusedDay,
                        );
                      },
                      child: Text(
                        DataUtils.getTimeFromDateTime(dateTime: selectedDay),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: WHITE_COLOR,
                            letterSpacing: 2.0),
                      ),
                    ),
                    Positioned(
                      right: -45,
                      top: -7,
                      child: Image.asset(
                        'assets/image/icon/love_icon.png',
                        scale: 4,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: const BorderSide(
                          width: 2,
                          color: WHITE_COLOR,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(WRITE_BUTTON),
                  ),
                  onPressed: () {
                    context.go(
                      '/detail/${widget.diaryId}/${DiaryPostScreen.routeName}',
                      extra: {
                        'diaryId': widget.diaryId,
                        'selectedDay': selectedDay,
                        'title': widget.title,
                      },
                    );
                  },
                  child: const Text(
                    '  글쓰기  ',
                    style: TextStyle(
                      color: DIARY_DETAIL_COLOR,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                height: MediaQuery.of(context).size.height - 150,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: WHITE_COLOR,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(
                    150,
                  ),
                  image: const DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      'assets/image/diary/diary4.jpg',
                    ),
                  ),
                ),
                child: getPostList.when(
                  data: (
                    data,
                  ) {
                    // 선택된 날짜에 해당하는 게시물만 필터링하기
                    final filteredData = data
                        .where((post) => isSameDate(post.dataTime, selectedDay))
                        .toList();

                    return ListView.builder(
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final diaryData = filteredData[index];
                        return DiaryDetailCard.fromModel(
                          editOnPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DiaryPostScreen(
                                  postId: diaryData.postId,
                                  diaryId: widget.diaryId,
                                  edit: true,
                                  diaryTitle: widget.title!,
                                  selectedDay: selectedDay,
                                ),
                              ),
                            );
                          },
                          deleteOnpress: () {
                            ref
                                .watch(diaryDetailProvider.notifier)
                                .deletePostFromFirestore(
                                  diaryData.postId.toString(),
                                );
                            context.pop();
                          },
                          diaryData: diaryData,
                          color: colors[index % colors.length],
                          divColor: divColors[index % divColors.length],
                          inputFieldNode: inputFieldNode,
                          contentController: contentController,
                          sendOnpress: () {
                            setState(() {
                              String content = contentController.text;
                              DiaryCommentModel commentPost = DiaryCommentModel(
                                dataTime: focusedDay,
                                postId: diaryData.postId,
                                content: content,
                              );

                              ref
                                  .watch(diaryDetailProvider.notifier)
                                  .saveCommentToFirestore(
                                    commentPost,
                                  );
                              contentController.clear();
                            });
                          },
                        );
                      },
                    );
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

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // onDaySelected(
  //   selectedDay,
  //   focusedDay,
  // ) {
  //   setState(() {
  //     this.selectedDay = selectedDay;
  //     this.focusedDay = selectedDay;
  //   });
  // }

  void _showCalendarModal(
    selectedDay,
    focusedDay,
  ) {
    final dialogContext = context;
    showDialog(
      context: dialogContext,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            // 모달 ui setState
            onDaySelected(DateTime selectedDate, DateTime focusedDate) {
              modalSetState(() {
                selectedDay = selectedDate;
                focusedDay = selectedDate;
              });
              setState(() {
                this.selectedDay = selectedDate;
                ref.watch(selectedDateStateProvider.notifier).state =
                    selectedDate;
              });
              context.pop();
            }

            return Calendar(
              selectedDay: selectedDay,
              onDaySelected: onDaySelected,
              focusedDay: focusedDay,
              // diaryId: widget.diaryId,
            );
          },
        );
      },
    );
  }
}
