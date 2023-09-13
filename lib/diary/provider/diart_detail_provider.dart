import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youandi_diary/diary/model/diary_post_model.dart';


final diaryDetailProvider =
    StateNotifierProvider<DiartDetailProvider, PostState>((ref) => DiartDetailProvider());

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
      model.dataTime = DateTime.now();

      await docRef.set(model.toJson());

      state = PostState(post: model);
      
    } catch (e) {
      state = PostState(error: e.toString());
    }
  }
}

