// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:youandi_diary/user/model/user_alarm_model.dart';

import '../../diary/provider/diart_detail_provider.dart';

final userAlarmProvider = StateNotifierProvider<UserAlarmProvider, AlarmState>(
    (ref) => UserAlarmProvider());

class AlarmState {
  final UserAlarmModel? alarm;
  final bool isLoading;
  final String? error;

  AlarmState({
    this.alarm,
    this.isLoading = false,
    this.error,
  });
}

class UserAlarmProvider extends StateNotifier<AlarmState> {
  UserAlarmProvider() : super(AlarmState());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 댓글 불러오기
  Stream<List<UserAlarmModel>> getAlarmListFromFirestore() {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(currentUser?.uid)
        .collection('alarm')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserAlarmModel.fromJson(doc.data()))
            .toList());
  }
}
