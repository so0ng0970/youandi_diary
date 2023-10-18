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

User? currentUser = FirebaseAuth.instance.currentUser;

class DiartDetailProvider extends StateNotifier<PostState> {
  DiartDetailProvider() : super(PostState());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 글 저장
  Future<void> savePostToFirestore(DiaryPostModel model) async {
    state = PostState(isLoading: true);

    try {
      DocumentReference docRef = _firestore
          .collection('user')
          .doc(currentUser?.uid)
          .collection('post')
          .doc();
      DocumentReference postRef = _firestore
          .collection('diary')
          .doc(model.diaryId)
          .collection('post')
          .doc(docRef.id);

      if (currentUser != null) {
        DocumentSnapshot userData =
            await _firestore.collection('user').doc(currentUser!.uid).get();
        model.userId = currentUser!.uid;
        if (userData.exists) {
          model.userName = userData['userName'] ?? '';
          model.photoUrl = userData['photoUrl'] ?? '';
          model.postId = docRef.id;
        } else {
          model.userName = currentUser?.displayName ?? '';
          model.photoUrl = currentUser?.photoURL ?? '';
        }
      }

      await docRef.set(model.toJson());
      await postRef.set(model.toJson());

      model.postId = docRef.id;

      state = PostState(post: model);
    } catch (e) {
      state = PostState(error: e.toString());
    }
  }

  // 유저 다이어리
  Stream<List<DocumentSnapshot>> getMyDiaryListScrollFromFirestore(
      String diaryId,
      DateTime? selectedDay,
      DocumentSnapshot? pageKey,
      int pageSize) {
    final start = DateTime(
        selectedDay?.year ?? DateTime.now().year,
        selectedDay?.month ?? DateTime.now().month,
        selectedDay?.day ?? DateTime.now().day);
    final end = start.add(const Duration(days: 1));

    Query firebase = FirebaseFirestore.instance
        .collection('user')
        .doc(currentUser?.uid)
        .collection('diary')
        .doc(diaryId)
        .collection('post')
        .where('diaryId', isEqualTo: diaryId)
        .orderBy(
          'dataTime',
          descending: true,
        )
        .where('dataTime', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('dataTime', isLessThan: Timestamp.fromDate(end))
        .limit(pageSize);

    if (pageKey != null) {
      firebase = firebase.startAfterDocument(pageKey);
    }
    return firebase.snapshots().map((snapshot) => snapshot.docs);
  }

  // 다이어리 스크롤 - get
  Stream<List<DocumentSnapshot>> getDiaryListScrollFromFirestore(String diaryId,
      DateTime? selectedDay, DocumentSnapshot? pageKey, int pageSize) {
    final start = DateTime(
        selectedDay?.year ?? DateTime.now().year,
        selectedDay?.month ?? DateTime.now().month,
        selectedDay?.day ?? DateTime.now().day);
    final end = start.add(const Duration(days: 1));

    Query firebase = FirebaseFirestore.instance
        .collection('diary')
        .doc(diaryId)
        .collection('post')
        .where('diaryId', isEqualTo: diaryId)
        .orderBy(
          'dataTime',
          descending: true,
        )
        .where('dataTime', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('dataTime', isLessThan: Timestamp.fromDate(end))
        .limit(pageSize);

    if (pageKey != null) {
      firebase = firebase.startAfterDocument(pageKey);
    }
    return firebase.snapshots().map((snapshot) => snapshot.docs);
  }

// 전체 글 불러오기
  Stream<List<DocumentSnapshot>> getAllPosts(
    DocumentSnapshot? pageKey,
    int pageSize,
  ) {
    Query firebase = FirebaseFirestore.instance
        .collection('user')
        .doc(currentUser?.uid)
        .collection('post')
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

  // 전체 글과 댓글 삭제
  Future<void> deleteSelectedPostsAndCommentsFromFirestore({
    required List<String> postIds,
    required String diaryId,
  }) async {
    try {
      WriteBatch batch = _firestore.batch();

      for (String postId in postIds) {
      
        QuerySnapshot userCommentsSnapshot = await _firestore
            .collection('user')
            .doc(currentUser?.uid)
            .collection('comment')
            .where('postId', isEqualTo: postId)
            .get();

        for (DocumentSnapshot doc in userCommentsSnapshot.docs) {
          batch.delete(doc.reference);
        }

      
        QuerySnapshot postCommentsSnapshot = await _firestore
            .collection('diary')
            .doc(diaryId)
            .collection('post')
            .doc(postId)
            .collection('comment')
            .get();

        for (DocumentSnapshot doc in postCommentsSnapshot.docs) {
          batch.delete(doc.reference);
        }

      
        DocumentReference diaryPostRef = _firestore
            .collection('diary')
            .doc(diaryId)
            .collection('post')
            .doc(postId);

        batch.delete(diaryPostRef);


        DocumentReference userPostRef = _firestore
            .collection('user')
            .doc(currentUser?.uid)
            .collection('post')
            .doc(postId);

        batch.delete(userPostRef);
      }

      await batch.commit();
    } catch (e) {
      print(e.toString());
    }
  }

  // 글 불러오기 GET
  Stream<List<DiaryPostModel>> getDiaryListFromFirestore(
      String diaryId, DateTime selectedDay) {
    final start =
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    final end =
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day + 1);

    return FirebaseFirestore.instance
        .collection('diary')
        .doc(diaryId)
        .collection('post')
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
  Future<void> deletePostFromFirestore({
    required String postId,
    required String diaryId,
  }) async {
    try {
      DocumentReference postRef = _firestore
          .collection('diary')
          .doc(diaryId)
          .collection('post')
          .doc(postId);
      DocumentReference allPostRef = _firestore
          .collection('user')
          .doc(currentUser?.uid)
          .collection('post')
          .doc(postId);
      QuerySnapshot commentQuerySnapshot =
          await postRef.collection('comment').get();

      for (var commentDoc in commentQuerySnapshot.docs) {
        commentDoc.reference.delete();
      }
      await postRef.delete();
      await allPostRef.delete();
    } catch (e) {
      print(e.toString());
    }
  }

  // 글 수정
  Future<void> updatePostInFirestore({
    required String postId,
    List<String>? imgUrl,
    required String content,
    required String title,
    String? videoUrl,
    required String diaryId,
  }) async {
    try {
      await _firestore
          .collection('diary')
          .doc(
            diaryId,
          )
          .collection('post')
          .doc(postId)
          .update({
        'imgUrl': imgUrl,
        'content': content,
        'title': title,
        'videoUrl': videoUrl
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
