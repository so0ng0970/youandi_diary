import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youandi_diary/diary/model/diary_comment_model.dart';
import 'package:youandi_diary/diary/model/diary_post_model.dart';

final getPostListProvider = StreamProvider.autoDispose
    .family<List<DiaryPostModel>, String>((ref, diaryId) {
  final selectedDate = ref.watch(selectedDateStateProvider);

  return ref
      .watch(diaryDetailProvider.notifier)
      // getDiaryListFromFirestore 메소드 호출 시 선택된 날짜 전달하기
      .getDiaryListFromFirestore(diaryId, selectedDate);
});

final getCommentListProvider = StreamProvider.autoDispose
    .family<List<DiaryCommentModel>, String>((ref, postId) {
  return ref.watch(diaryDetailProvider.notifier).getCommentListFromFirestore(
        postId,
      );
});

final diaryDetailProvider =
    StateNotifierProvider<DiartDetailProvider, PostState>(
        (ref) => DiartDetailProvider());
final selectedDateStateProvider =
    StateProvider<DateTime>((ref) => DateTime.now());

class PostState {
  final bool isLoading;
  final String? error;
  final DiaryPostModel? post;
  final DiaryCommentModel? comment;

  PostState({this.isLoading = false, this.error, this.post, this.comment});
}

class DiartDetailProvider extends StateNotifier<PostState> {
  DiartDetailProvider() : super(PostState());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 글 저장
  Future<void> savePostToFirestore(DiaryPostModel model) async {
    state = PostState(isLoading: true);

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      DocumentReference docRef = _firestore.collection('post').doc();

      if (currentUser != null) {
        DocumentSnapshot userData =
            await _firestore.collection('user').doc(currentUser.uid).get();
        model.userId = currentUser.uid;
        if (userData.exists) {
          model.userName = userData['userName'] ?? '';
          model.photoUrl = userData['photoUrl'] ?? '';
        } else {
          model.userName = currentUser.displayName ?? '';
          model.photoUrl = currentUser.photoURL ?? '';
        }
      }

      model.postId = docRef.id;

      await docRef.set(model.toJson());

      state = PostState(post: model);
    } catch (e) {
      state = PostState(error: e.toString());
    }
  }

  Stream<List<DiaryPostModel>> getDiaryListFromFirestore(
      String diaryId, DateTime selectedDay) {
    final start =
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    final end =
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day + 1);

    return FirebaseFirestore.instance
        .collection('post')
        .where('diaryId', isEqualTo: diaryId)
        .orderBy(
          'dataTime',
          descending: true,
        )
        .where('dataTime', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('dataTime', isLessThan: Timestamp.fromDate(end))
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DiaryPostModel.fromJson(doc.data()))
            .toList());
  }

  // 글 삭제
  Future<void> deletePostFromFirestore(String postId) async {
    try {
      await _firestore.collection('post').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  // 글 수정
  Future<void> updatePostInFirestore(
    String postId,
    List<String>? imgUrl,
    String content,
    String title,
    String? videoUrl,
  ) async {
    try {
      await _firestore.collection('post').doc(postId).update({
        'imgUrl': imgUrl,
        'content': content,
        'title': title,
        'videoUrl': videoUrl
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // 댓글 저장
  Future<void> saveCommentToFirestore(DiaryCommentModel model) async {
    state = PostState(isLoading: true);

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      DocumentReference docRef = _firestore.collection('comment').doc();

      if (currentUser != null) {
        model.userId = currentUser.uid;

        DocumentSnapshot userData =
            await _firestore.collection('user').doc(currentUser.uid).get();

        if (userData.exists) {
          model.userName = userData['userName'] ?? '';
          model.photoUrl = userData['photoUrl'] ?? '';
        } else {
          model.userName = currentUser.displayName ?? '';
          model.photoUrl = currentUser.photoURL ?? '';
        }
      }

      model.commentId = docRef.id;

      await docRef.set(model.toJson());

      state = PostState(comment: model);
    } catch (e) {
      state = PostState(error: e.toString());
    }
  }

  // 댓글 삭제
  Future<void> deleteCommentFromFirestore(String commentId) async {
    try {
      await _firestore.collection('comment').doc(commentId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<List<DiaryCommentModel>> getCommentListFromFirestore(String postId) {
    return FirebaseFirestore.instance
        .collection('comment')
        .where('postId', isEqualTo: postId)
        .orderBy(
          'dataTime',
          descending: true,
        )
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DiaryCommentModel.fromJson(doc.data()))
            .toList());
  }

  // 댓글 수정
  Future<void> updateCommentInFirestore(
    String commentId,
    String comment,
  ) async {
    try {
      await _firestore.collection('comment').doc(commentId).update(
        {
          'comment': comment,
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
