import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youandi_diary/diary/model/diary_model.dart';
import 'package:youandi_diary/user/model/user_model.dart';

final diaryProvider = Provider<DiaryRepository>((ref) => DiaryRepository());
final diaryListProvider = ChangeNotifierProvider<DiaryListNotifier>(
    (ref) => DiaryListNotifier(repository: ref.read(diaryProvider)));

class DiaryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<DiaryModel> saveDiaryToFirestore(DiaryModel diary) async {
    DocumentReference docRef = _firestore.collection('diary').doc();
    final userData = {
      'diaryId': docRef.id,
      'title': diary.title,
      'dataTime': DateTime.now(),
      'coverImg': diary.coverImg,
      'member': diary.member.map((UserModel user) => user.toJson()).toList(),
    };

    if (diary.diaryId == null) {
      DocumentReference docRef = _firestore.collection('diary').doc();
      diary.diaryId = docRef.id;
      await docRef.set(userData);
    }

    return diary;
  }

  Stream<List<DiaryModel>> getDiaryListFromFirestore() {
    return _firestore
        .collection('diary')
        .orderBy('dataTime', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      final List<DiaryModel> diaryList = query.docs
          .map((doc) => DiaryModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return diaryList;
    });
  }
}

class DiaryListNotifier with ChangeNotifier {
  DiaryListNotifier({required this.repository}) {
    loadDiaries();
  }

  final DiaryRepository repository;

  List<DiaryModel> _diaryList = [];
  bool _isLoading = false;

  List<DiaryModel> get diaryList => _diaryList;
  bool get isLoading => _isLoading;

  Future<void> addDiary(DiaryModel diary) async {
    if (_diaryList.contains(diary)) {
      return;
    }
    _isLoading = true;
    notifyListeners();

    final savedDiary = await repository.saveDiaryToFirestore(diary);
    _diaryList = [..._diaryList, savedDiary];

    _isLoading = false;
    notifyListeners();
  }

  StreamSubscription<List<DiaryModel>>? _diaryListStream;
  @override
  void dispose() {
    _diaryListStream?.cancel();
    super.dispose();
  }

  Future<void> loadDiaries() async {
    _isLoading = true;
    notifyListeners();

    _diaryListStream?.cancel();
    _diaryListStream = repository
        .getDiaryListFromFirestore()
        .listen((List<DiaryModel> listOfDiary) {
      _diaryList = listOfDiary;
      _isLoading = false;
      notifyListeners();
    });
  }
}
