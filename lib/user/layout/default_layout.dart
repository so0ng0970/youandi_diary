// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:youandi_diary/common/component/main_drawer.dart';
import 'package:youandi_diary/user/component/alarm_list.dart';

import '../../common/const/color.dart';

class DefaultLayout extends StatelessWidget {
  final Color? color;
  final Widget child;
  final String? title;
  final Widget? icon;
  final VoidCallback? popOnPressed;
  bool? drawerBool;
  bool? homeScreen;
  bool? backBool;
  DefaultLayout(
      {Key? key,
      this.color,
      required this.child,
      this.title,
      this.icon,
      this.popOnPressed,
      this.drawerBool = true,
      this.homeScreen = false,
      this.backBool = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      extendBodyBehindAppBar: true,
      // 앱바 투명하게 가능
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          title ?? '',
        ),
        actions: [
          IconButton(
            onPressed: () {
              mediaDialog(context);
            },
            icon: const Icon(
              Icons.notifications_none,
              color: WHITE_COLOR,
            ),
          ),
          if (icon == null && backBool == true)
            IconButton(
              onPressed: popOnPressed,
              icon: const Icon(Icons.arrow_back),
            )
        ],
      ),

      drawer: drawerBool == true ? const MainDrawer() : null,

      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: homeScreen == true ? 0 : 16.0,
        ),
        child: child,
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
