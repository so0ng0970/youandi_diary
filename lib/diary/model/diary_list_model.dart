import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryListModel {
  late String? diaryId;
  late String title;
  late String coverImg;
  late List<Map<String, dynamic>> member;

  DiaryListModel({
    this.diaryId,
    required this.title,
    required this.coverImg,
    required this.member,
  });

  DiaryListModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    diaryId = snapshot.id;
    title = data['title'] ?? '';
    coverImg = data['coverImg'] ?? '';
    member = member;
  }
}
