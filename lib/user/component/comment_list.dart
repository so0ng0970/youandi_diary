import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:skeletons/skeletons.dart';
import 'package:youandi_diary/diary/model/diary_comment_model.dart';
import 'package:youandi_diary/diary/provider/diary_comment_provider.dart';

import '../../common/const/color.dart';
import '../../common/utils/data_utils.dart';

class CommentList extends ConsumerStatefulWidget {
  const CommentList({super.key});

  @override
  ConsumerState<CommentList> createState() => _CommentListState();
}

class _CommentListState extends ConsumerState<CommentList> {
  final PagingController<DocumentSnapshot?, DiaryCommentModel>
      pagingController = PagingController(firstPageKey: null);
  String? diaryId;
  String? postId;
  bool deleted = false;
  static const pageSize = 12;
  Map<String, bool> checkboxStates = {};
  Map<String, String> postIds = {};
  Map<String, String> diaryIds = {};

  @override
  void initState() {
    super.initState();

    pagingController.addPageRequestListener((pageKey) {
      fetchAllPage(pageKey);
    });
  }

  Future<void> fetchAllPage(DocumentSnapshot? pageKey) async {
    try {
      print('Fetching new page...');
      final newSnapshots =
          await ref.watch(diaryCommentProvider.notifier).getAllComments(
                pageKey,
                pageSize,
              );
      if (newSnapshots.isEmpty) {
        pagingController.appendLastPage([]);
        return;
      }
      final newItems = newSnapshots
          .map((snapshot) => DiaryCommentModel.fromJson(
              snapshot.data() as Map<String, dynamic>))
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
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => Future.sync(() => pagingController.refresh()),
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
                    List<String> selectedCommentIds =
                        checkboxStates.keys.toList();
                    for (String commentId in selectedCommentIds) {
                      String? postId = postIds[commentId];
                      String? diaryId = diaryIds[commentId];
                      if (postId != null && diaryId != null) {
                        ref
                            .watch(diaryCommentProvider.notifier)
                            .deleteSelectedCommentsFromFirestore(
                          commentIds: [commentId],
                          diaryIds: {commentId: diaryId},
                          postIds: {commentId: postId},
                        );
                      }
                    }
                    checkboxStates.clear();
                    diaryIds.clear();
                    postIds.clear();
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
              child: PagedListView<DocumentSnapshot?, DiaryCommentModel>(
                pagingController: pagingController,
                builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: ((context, item, index) {
                    final data = pagingController.itemList![index];
                    diaryId = pagingController.itemList![index].diaryId;

                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (deleted) {
                              checkboxStates[data.commentId.toString()] =
                                  !(checkboxStates[data.commentId.toString()] ??
                                      false);

                              if (checkboxStates[data.commentId.toString()]!) {
                                diaryIds[data.commentId.toString()] =
                                    data.diaryId.toString();
                                postIds[data.commentId.toString()] =
                                    data.postId.toString();
                              } else {
                                diaryIds.remove(
                                  data.diaryId.toString(),
                                );
                                postIds.remove(
                                  data.postId.toString(),
                                );
                              }
                            }
                          });
                        },
                        child: Container(
                          height: deleted ? 85 : 60,
                          decoration: const BoxDecoration(
                            color: CMLIST,
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      data.postId != null
                                          ? '${data.diaryTittle.toString()}  글 제목: ${data.postTittle.toString()}'
                                          : '삭제된 글 입니다',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const Spacer(),
                                    if (deleted)
                                      Checkbox(
                                          value:
                                              checkboxStates[data.commentId] ??
                                                  false,
                                          onChanged: (value) {
                                            setState(() {
                                              checkboxStates[data.commentId
                                                  .toString()] = value!;
                                              if (checkboxStates[
                                                  data.commentId.toString()]!) {
                                                postIds[data.commentId
                                                        .toString()] =
                                                    data.postId.toString();
                                                diaryIds[data.commentId
                                                        .toString()] =
                                                    data.diaryId.toString();
                                              } else {
                                                postIds.remove(
                                                    data.postId.toString());
                                                diaryIds.remove(
                                                    data.diaryId.toString());
                                              }
                                            });
                                          })
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      data.content.toString(),
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
            )
          ],
        ),
      ),
    );
  }

  SizedBox listView = SizedBox(
    height: 60,
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
