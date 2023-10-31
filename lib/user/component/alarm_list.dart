import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youandi_diary/user/provider/user_alarm_provider.dart';

import '../model/user_alarm_model.dart';

class AlarmList extends ConsumerStatefulWidget {
  const AlarmList({super.key});

  @override
  ConsumerState<AlarmList> createState() => _AlarmListState();
}

class _AlarmListState extends ConsumerState<AlarmList> {
  @override
  Widget build(BuildContext context) {
    final provider =
        ref.watch(userAlarmProvider.notifier).getAlarmListFromFirestore();
    return Dialog(
      child: SizedBox(
        width: 300,
        height: 450,
        child: StreamBuilder<List<UserAlarmModel>>(
          stream: provider,
          builder: (BuildContext context,
              AsyncSnapshot<List<UserAlarmModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<UserAlarmModel> alarmList = snapshot.data ?? [];

              return ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  UserAlarmModel alarm = alarmList[index];
                  return SizedBox(
                    height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${alarm.userName}이 댓글을 남겼습니다'),
                      ],
                    ),
                  );
                },
                itemCount: alarmList.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              );
            }
          },
        ),
      ),
    );
  }
}
