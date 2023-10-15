import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import 'package:youandi_diary/diary/model/diary_comment_model.dart';
import 'package:youandi_diary/diary/model/diary_post_model.dart';

final getCommentListProvider = StreamProvider.autoDispose
    .family<List<DiaryCommentModel>, Tuple2<String, String>>((ref, ids) {
  final diaryId = ids.item1;
  final postId = ids.item2;
  return ref
      .watch(diaryCommentProvider.notifier)
      .getCommentListFromFirestore(postId: postId, diaryId: diaryId);
});

final diaryCommentProvider =
    StateNotifierProvider<DiaryCommentProvider, CommentState>(
        (ref) => DiaryCommentProvider());

class CommentState {
  final bool isLoading;
  final String? error;
  final DiaryPostModel? post;
  final DiaryCommentModel? comment;

  CommentState({this.isLoading = false, this.error, this.post, this.comment});
}

User? currentUser = FirebaseAuth.instance.currentUser;

class DiaryCommentProvider extends StateNotifier<CommentState> {
  DiaryCommentProvider() : super(CommentState());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 댓글 저장
  Future<void> saveCommentToFirestore({
    required DiaryCommentModel model,
    required String diaryId,
    required String postId,
  }) async {
    state = CommentState(isLoading: true);

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      DocumentReference docRef = _firestore
          .collection('user')
          .doc(currentUser?.uid)
          .collection('diary')
          .doc(diaryId)
          .collection('post')
          .doc(postId)
          .collection('comment')
          .doc();

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

      state = CommentState(comment: model);
    } catch (e) {
      state = CommentState(error: e.toString());
    }
  }

  // 댓글 삭제
  Future<void> deleteCommentFromFirestore({
    required String commentId,
    required String diaryId,
    required String postId,
  }) async {
    try {
      await _firestore
          .collection('user')
          .doc(currentUser?.uid)
          .collection('diary')
          .doc(diaryId)
          .collection('post')
          .doc(postId)
          .collection('comment')
          .doc(commentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  // 댓글 불러오기
  Stream<List<DiaryCommentModel>> getCommentListFromFirestore(
      {String? diaryId, required String postId}) {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(currentUser?.uid)
        .collection('diary')
        .doc(diaryId)
        .collection('post')
        .doc(postId)
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
  Future<void> updateCommentInFirestore({
    required String diaryId,
    required String postId,
    required String commentId,
    required String comment,
  }) async {
    try {
      await _firestore
          .collection('user')
          .doc(currentUser?.uid)
          .collection('diary')
          .doc(diaryId)
          .collection('post')
          .doc(postId)
          .collection('comment')
          .doc(commentId)
          .update(
        {
          'content': comment,
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  // 전체 댓글 불러오기
  Stream<List<DocumentSnapshot>> getAllComments(
      DocumentSnapshot? pageKey, int pageSize, String diaryId) {
    Query firebase = FirebaseFirestore.instance
        .collectionGroup('comment')
        .where('userId', isEqualTo: currentUser?.uid)
        .orderBy(
          'dataTime',
          descending: true,
        )
        .limit(pageSize);

    if (pageKey != null) {
      firebase = firebase.startAfterDocument(pageKey);
    }
    return firebase.snapshots().map((snapshot) => snapshot.docs);
  }

// 선택된 댓글 삭제
  Future<void> deleteSelectedCommentsFromFirestore({
    required List<String> commentIds,
    required String diaryId,
    required String postId,
  }) async {
    try {
      WriteBatch batch = _firestore.batch();

      for (String commentId in commentIds) {
        DocumentReference postRef = _firestore
            .collection('user')
            .doc(currentUser?.uid)
            .collection('diary')
            .doc(diaryId)
            .collection('post')
            .doc(postId)
            .collection('comment')
            .doc(commentId);

        batch.delete(postRef);
      }

      await batch.commit();
    } catch (e) {
      print(e.toString());
    }
  }
}
