// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:youandi_diary/user/model/user_alarm_model.dart';

import '../../diary/provider/diart_detail_provider.dart';

final alarmStreamProvider =
    StreamProvider.autoDispose<List<UserAlarmModel>>((ref) {
  return ref.read(userAlarmProvider.notifier).getAlarmListFromFirestore();
});
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

  // 알림 불러오기
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

  // 알림 삭제
  Future<void> deleteAlarmFromFirestore({
    required String alarmId,
  }) async {
    try {
      await _firestore
          .collection('user')
          .doc(currentUser?.uid)
          .collection('alarm')
          .doc(alarmId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  //  알림 읽음 처리
  Future<void> markAllAlarmsAsChecked(List<UserAlarmModel> alarms) async {
    for (var alarm in alarms) {
      try {
        await _firestore
            .collection('user')
            .doc(currentUser?.uid)
            .collection('alarm')
            .doc(alarm.alarmId)
            .update({'isChecked': true});
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
