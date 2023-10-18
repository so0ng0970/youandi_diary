import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:skeletons/skeletons.dart';
import 'package:youandi_diary/diary/component/diary_detail_card.dart';

import '../../common/const/color.dart';
import '../../common/utils/data_utils.dart';
import '../../diary/model/diary_comment_model.dart';
import '../../diary/model/diary_post_model.dart';
import '../../diary/provider/diart_detail_provider.dart';
import '../../diary/provider/diary_comment_provider.dart';
import '../../diary/screen/diary_post_screen.dart';

class PostList extends ConsumerStatefulWidget {
  const PostList({super.key});

  @override
  ConsumerState<PostList> createState() => _PostListState();
}

class _PostListState extends ConsumerState<PostList> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  late FocusNode inputFieldNode;
  final TextEditingController contentController = TextEditingController();
  static const pageSize = 12;
  final PagingController<DocumentSnapshot?, DiaryPostModel> pagingController =
      PagingController(firstPageKey: null);
  String? diaryId;
  bool deleted = false;
  Map<String, bool> checkboxStates = {};
  Map<String, String> diaryIds = {};

  @override
  void initState() {
    super.initState();
    inputFieldNode = FocusNode();
    pagingController.addPageRequestListener((pageKey) {
      fetchAllPage(pageKey);
    });
  }

  @override
  void dispose() {
    inputFieldNode.dispose();
    pagingController.dispose();
    super.dispose();
  }

  Future<void> fetchAllPage(DocumentSnapshot? pageKey) async {
    try {
      final newSnapshots = await ref
          .watch(diaryDetailProvider.notifier)
          .getAllPosts(
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
      } else {
        final nextPageKey = newSnapshots.last;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => pagingController.refresh(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!deleted)
              IconButton(
                onPressed: () {
                  setState(() {
                    deleted = true;
                  });
                },
                icon: const Icon(
                  Icons.delete_outline,
                  color: DELETE_BUTTON,
                ),
              ),
            if (deleted)
              IconButton(
                onPressed: () {
                  setState(() {
                    List<String> selectedPostIds = checkboxStates.keys.toList();
                    for (String postId in selectedPostIds) {
                      String? diaryId = diaryIds[postId];
                      print(diaryIds);
                      if (diaryId != null) {
                        ref
                            .watch(diaryDetailProvider.notifier)
                            .deleteSelectedPostsAndCommentsFromFirestore(
                          postIds: [postId],
                          diaryId: diaryId,
                        );
                      }
                    }
                    checkboxStates.clear();
                    diaryIds.clear();
                    pagingController.refresh();
                    deleted = false;
                  });
                },
                icon: const Icon(
                  Icons.check,
                ),
              ),
            SizedBox(
              height: 490,
              child: PagedListView<DocumentSnapshot?, DiaryPostModel>(
                pagingController: pagingController,
                builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: ((context, item, index) {
                    final data = pagingController.itemList![index];
                    diaryId = pagingController.itemList![index].diaryId;
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: GestureDetector(
                        onTap: () async {
                          if (!deleted) {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Scaffold(
                                    backgroundColor: TWOCOLOR,
                                    extendBodyBehindAppBar: true,
                                    // 앱바 투명하게 가능
                                    appBar: AppBar(
                                      centerTitle: true,
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      title: Text(
                                        data.diaryTittle ?? '',
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
                                                  postId: data.postId,
                                                  diaryId:
                                                      data.diaryId.toString(),
                                                  edit: true,
                                                  diaryTitle: data.title!,
                                                  selectedDay: selectedDay,
                                                  pagingController:
                                                      pagingController,
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
                                                    diaryId:
                                                        data.diaryId.toString(),
                                                    postId:
                                                        data.postId.toString(),
                                                  );
                                              pagingController.refresh();
                                              context.pop();
                                            });
                                            context.pop();
                                          },
                                          diaryData: data,
                                          color: ONECOLOR,
                                          divColor: DIVONE,
                                          inputFieldNode: inputFieldNode,
                                          contentController: contentController,
                                          sendOnpress: () {
                                            setState(() {
                                              String content =
                                                  contentController.text;
                                              DiaryCommentModel commentPost =
                                                  DiaryCommentModel(
                                                diaryId: data.diaryId,
                                                dataTime: focusedDay,
                                                postId: data.postId,
                                                content: content,
                                                postTittle: data.title,
                                                diaryTittle: data.diaryTittle,
                                              );

                                              ref
                                                  .watch(diaryCommentProvider
                                                      .notifier)
                                                  .saveCommentToFirestore(
                                                    diaryId:
                                                        data.diaryId.toString(),
                                                    model: commentPost,
                                                    postId: commentPost.postId
                                                        .toString(),
                                                  );
                                              contentController.clear();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            setState(() {
                              checkboxStates[data.postId.toString()] =
                                  !(checkboxStates[data.postId.toString()] ??
                                      false);
                              if (checkboxStates[data.postId.toString()]!) {
                                diaryIds[data.postId.toString()] =
                                    data.diaryId.toString();
                              } else {
                                diaryIds.remove(data.postId.toString());
                              }
                            });
                          }
                        },
                        child: Container(
                          height: deleted ? 120 : 100,
                          decoration: const BoxDecoration(
                            color: ADD_BG_COLOR,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        '${data.diaryTittle.toString()}    ',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      data.title.toString(),
                                      style: const TextStyle(
                                        fontSize: 17,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Spacer(),
                                    if (deleted)
                                      Checkbox(
                                          value: checkboxStates[data.postId] ??
                                              false,
                                          onChanged: (value) {
                                            setState(() {
                                              checkboxStates[data.postId
                                                  .toString()] = value!;
                                              if (checkboxStates[
                                                  data.postId.toString()]!) {
                                                diaryIds[data.postId
                                                        .toString()] =
                                                    data.diaryId.toString();
                                              } else {
                                                diaryIds.remove(
                                                    data.postId.toString());
                                              }
                                            });
                                          })
                                  ],
                                ),
                                Row(
                                  children: [
                                    if (data.imgUrl!.isNotEmpty)
                                      Image.network(
                                        data.imgUrl![0],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    Column(
                                      children: [
                                        Text(
                                          data.content.toString(),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Center(
                                  child: Text(
                                    DataUtils.getTimeFromDateTime(
                                      dateTime: data.dataTime,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  noItemsFoundIndicatorBuilder: (context) => const Center(
                    child: Text(
                      '글을 작성해 주세요',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  firstPageErrorIndicatorBuilder: (context) => const Center(
                    child: Text(
                      '글이 없습니다',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  newPageErrorIndicatorBuilder: (context) =>
                      const Text('새 페이지 데이터 정보를 불러오지 못했습니다'),
                  firstPageProgressIndicatorBuilder: (context) => listView,
                  newPageProgressIndicatorBuilder: (context) => listView,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox listView = SizedBox(
    height: 600,
    child: ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.all(15.0),
        child: SkeletonAvatar(
          style: SkeletonAvatarStyle(
            width: double.infinity,
            height: 100,
          ),
        ),
      ),
    ),
  );
}
