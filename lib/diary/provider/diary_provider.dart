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
    final userData = {
      'title': diary.title,
      'dataTime': diary.dataTime,
      'coverImg': diary.coverImg,
      'member': diary.member.map((UserModel user) => user.toJson()).toList(),
    };
    DocumentReference docRef = _firestore.collection('diary').doc();
    diary.diaryId = docRef.id;
    await docRef.set(
      userData,
    );
    return diary;
  }

  Future<List<DiaryModel>> getDiaryListFromFirestore() async {
    final QuerySnapshot snapshot = await _firestore.collection('diary').get();
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
    _isLoading = true;
    notifyListeners();

    final savedDiary = await repository.saveDiaryToFirestore(diary);
    _diaryList = [..._diaryList, savedDiary];

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadDiaries() async {
    _isLoading = true;
    notifyListeners();

    _diaryList = await repository.getDiaryListFromFirestore();

    _isLoading = false;
    notifyListeners();
  }
}
