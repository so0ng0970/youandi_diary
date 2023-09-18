import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  PostState({this.isLoading = false, this.error, this.post});
}

class DiartDetailProvider extends StateNotifier<PostState> {
  DiartDetailProvider() : super(PostState());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> savePostToFirestore(DiaryPostModel model) async {
    state = PostState(isLoading: true);

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      DocumentReference docRef = _firestore.collection('post').doc();

      if (currentUser != null) {
        model.userName = currentUser.displayName ?? '';
        model.photoUrl = currentUser.photoURL ?? '';
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
        .where('dataTime', isGreaterThanOrEqualTo: start)
        .where('dataTime', isLessThan: end)
        .orderBy(
          'dataTime',
          descending: true,
        )
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DiaryPostModel.fromJson(doc.data()))
            .toList());
  }
}
