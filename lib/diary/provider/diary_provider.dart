import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youandi_diary/diary/model/diary_list_model.dart';

final diaryProvider = Provider<DiaryProvider>((ref) => DiaryProvider());

class DiaryProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> saveDiaryToFirestore(DiaryListModel diary) async {
    final userData = {
      'title': diary.title,
      'coverImg': diary.coverImg,
      'member': diary.member,
    };
    DocumentReference docRef = _firestore.collection('diary').doc();
    diary.diaryId = docRef.id;
    await docRef.set(
      userData,
    );
  }
}
