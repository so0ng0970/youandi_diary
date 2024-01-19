// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:youandi_diary/common/component/main_drawer.dart';
import 'package:youandi_diary/user/component/alarm_list.dart';
import 'package:badges/badges.dart' as badges;
import 'package:youandi_diary/user/provider/user_alarm_provider.dart';
import '../../common/const/color.dart';

class DefaultLayout extends ConsumerStatefulWidget {
  final Color? color;
  final Widget child;
  final String? title;
  final Widget? icon;
  bool? resizeToAvoidBottomInset;
  final VoidCallback? popOnPressed;
  bool? drawerBool;
  bool? homeScreen;
  bool? backBool;
  DefaultLayout({
    Key? key,
    this.color,
    required this.child,
    this.title,
    this.icon,
    this.popOnPressed,
    this.drawerBool = true,
    this.homeScreen = false,
    this.backBool = true,
    this.resizeToAvoidBottomInset,
  }) : super(key: key);

  @override
  ConsumerState<DefaultLayout> createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends ConsumerState<DefaultLayout> {
  @override
  Widget build(BuildContext context) {
    final alarmProvider = ref.watch(alarmStreamProvider);
    return Scaffold(
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      backgroundColor: widget.color,
      extendBodyBehindAppBar: true,
      // 앱바 투명하게 가능
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.title ?? '',
        ),
        actions: [
          alarmProvider.when(
            data: (data) {
              final uncheckedAlarms =
                  data.where((alarm) => alarm.isChecked == false);
              final uncheckedAlarmCount = uncheckedAlarms.length;
              final showBadge = uncheckedAlarmCount > 0;
              return badges.Badge(
                position: badges.BadgePosition.topEnd(top: 0, end: 0),
                showBadge: showBadge,
                ignorePointer: false,
                badgeContent: Text(
                  uncheckedAlarmCount.toString(),
                  style: const TextStyle(
                    color: WHITE_COLOR,
                  ),
                ),
                badgeAnimation: const badges.BadgeAnimation.rotation(
                  animationDuration: Duration(seconds: 1),
                  colorChangeAnimationDuration: Duration(seconds: 1),
                  loopAnimation: false,
                  curve: Curves.fastOutSlowIn,
                  colorChangeAnimationCurve: Curves.easeInCubic,
                ),
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: Colors.red,
                  borderSide: BorderSide(color: Colors.white, width: 1),
                  elevation: 0,
                ),
                child: IconButton(
                  onPressed: () {
                    ref
                        .watch(userAlarmProvider.notifier)
                        .markAllAlarmsAsChecked(data);
                    mediaDialog(context);
                  },
                  icon: const Icon(
                    Icons.notifications_none,
                    color: WHITE_COLOR,
                  ),
                ),
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => Text('Error: $error'),
          ),
          if (widget.icon == null && widget.backBool == true)
            IconButton(
              onPressed: widget.popOnPressed,
              icon: const Icon(Icons.arrow_back),
            )
        ],
      ),

      drawer: widget.drawerBool == true ? const MainDrawer() : null,

      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.homeScreen == true ? 0 : 16.0,
        ),
        child: widget.child,
      ),
    );
  }

  Future<dynamic> mediaDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlarmList();
      },
    );
  }
}
