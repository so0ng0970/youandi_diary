// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:youandi_diary/user/model/user_alarm_model.dart';

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
  User? currentUser = FirebaseAuth.instance.currentUser;
  Stream<List<UserAlarmModel>> getAlarmListFromFirestore() {
    if (currentUser != null) {
      return FirebaseFirestore.instance
          .collection('user')
          .doc(currentUser!.uid)
          .collection('alarm')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => UserAlarmModel.fromJson(doc.data()))
              .toList());
    } else {
      print("로그인하지 않은 사용자는 알림 정보를 가져올 수 없습니다.");
      return Stream.value([]);
    }
  }

  // 알림 삭제
  Future<void> deleteAlarmFromFirestore({
    required String alarmId,
  }) async {
    if (currentUser == null) {
      print("로그인하지 않은 사용자는 알림 정보를 삭제할 수 없습니다.");
      return;
    }
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
    if (currentUser == null) {
      print("로그인하지 않은 사용자는 알림 정보를 삭제할 수 없습니다.");
      return;
    }
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
