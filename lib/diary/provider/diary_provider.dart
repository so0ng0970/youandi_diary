import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      'memberUids': diary.member.map((UserModel user) => user.uid).toList(),
      'member': diary.member.map((UserModel user) => user.toJson()).toList(),
    };
    if (diary.diaryId == null) {
      DocumentReference docRef = _firestore.collection('diary').doc();
      diary.diaryId = docRef.id;
      await docRef.set(userData);
    }

    return diary;
  }

  Future<DiaryModel?> getDiaryById(String diaryId) async {
    final DocumentSnapshot snapshot =
        await _firestore.collection('diary').doc(diaryId).get();

    if (snapshot.exists) {
      return DiaryModel.fromJson(snapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<List<DiaryModel>> getDiaryListFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;

    final QuerySnapshot snapshot = await _firestore
        .collection('diary')
        .where('memberUids', arrayContains: user!.uid)
        .orderBy(
          'dataTime',
          descending: true,
        )
        .get();
    final List<DiaryModel> diaryList = [];
    for (var doc in snapshot.docs) {
      diaryList.add(DiaryModel.fromJson(doc.data() as Map<String, dynamic>));
    }

    return diaryList;
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
    await repository.saveDiaryToFirestore(diary);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadDiaries() async {
    _isLoading = true;
    notifyListeners();
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _isLoading = false;

      notifyListeners();
      return;
    }
    repository._firestore
        .collection('diary')
        .where('memberUids', arrayContains: user.uid)
        .orderBy('dataTime', descending: true)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      final List<DiaryModel> newDiaryList = [];
      for (var doc in snapshot.docs) {
        newDiaryList.add(
          DiaryModel.fromJson(
            doc.data() as Map<String, dynamic>,
          ),
        );
      }

      _diaryList = newDiaryList;
      _isLoading = false;
      notifyListeners();
    });
  }
}
