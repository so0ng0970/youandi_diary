// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:skeletons/skeletons.dart';
import 'package:youandi_diary/common/utils/data_utils.dart';
import 'package:youandi_diary/diary/component/diary_detail_card.dart';
import 'package:youandi_diary/diary/component/skeleton.dart';
import 'package:youandi_diary/diary/model/diary_comment_model.dart';
import 'package:youandi_diary/diary/model/diary_post_model.dart';
import 'package:youandi_diary/diary/provider/diart_detail_provider.dart';
import 'package:youandi_diary/diary/screen/diary_post_screen.dart';
import '../../common/const/color.dart';
import '../../user/layout/default_layout.dart';
import '../component/calendar.dart';
import '../provider/diary_comment_provider.dart';

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

  static const pageSize = 6;
  final PagingController<DocumentSnapshot?, DiaryPostModel> pagingController =
      PagingController(firstPageKey: null);

  @override
  void initState() {
    super.initState();
    inputFieldNode = FocusNode();
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });
  }

  @override
  void dispose() {
    inputFieldNode.dispose();
    pagingController.dispose();
    super.dispose();
  }

  Future<void> fetchPage(DocumentSnapshot? pageKey) async {
    try {
      print('Fetching new page...');
      final newSnapshots = await ref
          .watch(diaryDetailProvider.notifier)
          .getDiaryListScrollFromFirestore(
            widget.diaryId,
            selectedDay,
            pageKey,
            pageSize,
          )
          .firstWhere((event) => event != null);

      final newItems = newSnapshots
          .map((snapshot) =>
              DiaryPostModel.fromJson(snapshot.data() as Map<String, dynamic>))
          .toList();

      final isLastPage = newItems.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
        print('Fetched last page with ${newItems.length} items.');
      } else {
        final nextPageKey = newSnapshots.last;
        pagingController.appendPage(newItems, nextPageKey);
        print('Fetched new page with ${newItems.length} items.');
      }
    } catch (error) {
      print('Error fetching page: $error');
      pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
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
      drawerBool: false,
      backBool: false,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DiaryPostScreen(
                          selectedDay: selectedDay,
                          diaryTitle: widget.title.toString(),
                          diaryId: widget.diaryId,
                          edit: false,
                          pagingController: pagingController,
                        ),
                      ),
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
                child: RefreshIndicator(
                  onRefresh: () => Future.sync(
                    () => pagingController.refresh(),
                  ),
                  child: PagedListView<DocumentSnapshot?, DiaryPostModel>(
                    pagingController: pagingController,
                    builderDelegate: PagedChildBuilderDelegate<DiaryPostModel>(
                      itemBuilder: (context, diaryData, index) {
                        final diaryData = pagingController.itemList![index];
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
                                  pagingController: pagingController,
                                ),
                              ),
                            );
                          },
                          deleteOnpress: () async {
                            await ref
                                .watch(diaryDetailProvider.notifier)
                                .deletePostFromFirestore(
                                  diaryId: diaryData.diaryId.toString(),
                                  postId: diaryData.postId.toString(),
                                );

                            pagingController.refresh();
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
                                  diaryId: widget.diaryId,
                                  dataTime: focusedDay,
                                  postId: diaryData.postId,
                                  content: content,
                                  postTittle: diaryData.title,
                                  diaryTittle: widget.title);

                              ref
                                  .watch(diaryCommentProvider.notifier)
                                  .saveCommentToFirestore(
                                    diaryId: widget.diaryId.toString(),
                                    model: commentPost,
                                    postId: commentPost.postId.toString(),
                                  );
                              contentController.clear();
                            });
                          },
                        );
                      },
                      noItemsFoundIndicatorBuilder: (context) => const Center(
                        child: Text(
                          '글을 작성해 주세요',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      firstPageErrorIndicatorBuilder: (context) =>
                          const Text('데이터 정보를 불러오지 못했습니다 '),
                      newPageErrorIndicatorBuilder: (context) =>
                          const Text('새 페이지 데이터 정보를 불러오지 못했습니다'),
                      firstPageProgressIndicatorBuilder: (context) {
                        return const SkeletonComponent();
                      },
                      newPageProgressIndicatorBuilder: (context) {
                        return const SkeletonComponent();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final skeleton = SizedBox(
    height: 500,
    child: ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(color: Colors.white),
          child: SkeletonItem(
              child: Column(
            children: [
              Row(
                children: [
                  const SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                        shape: BoxShape.circle, width: 50, height: 50),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SkeletonParagraph(
                      style: SkeletonParagraphStyle(
                        lines: 3,
                        spacing: 6,
                        lineStyle: SkeletonLineStyle(
                          randomLength: true,
                          height: 10,
                          borderRadius: BorderRadius.circular(8),
                          minLength: MediaQuery.of(context).size.width / 6,
                          maxLength: MediaQuery.of(context).size.width / 3,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              SkeletonParagraph(
                style: SkeletonParagraphStyle(
                    lines: 3,
                    spacing: 6,
                    lineStyle: SkeletonLineStyle(
                      randomLength: true,
                      height: 10,
                      borderRadius: BorderRadius.circular(8),
                      minLength: MediaQuery.of(context).size.width / 2,
                    )),
              ),
              const SizedBox(height: 12),
              SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  width: double.infinity,
                  minHeight: MediaQuery.of(context).size.height / 8,
                  maxHeight: MediaQuery.of(context).size.height / 3,
                ),
              ),
            ],
          )),
        ),
      ),
    ),
  );
  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

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
                pagingController.refresh();
              });
              context.pop();
            }

            return Calendar(
              selectedDay: selectedDay,
              onDaySelected: onDaySelected,
              focusedDay: focusedDay,
            );
          },
        );
      },
    );
  }
}
