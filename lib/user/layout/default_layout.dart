// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:youandi_diary/common/component/main_drawer.dart';

import '../../common/const/color.dart';

class DefaultLayout extends StatelessWidget {
  final Color? color;
  final Widget child;
  final String? title;
  final Widget? icon;
  final VoidCallback? onPressed;
  final VoidCallback? popOnPressed;

  const DefaultLayout({
    Key? key,
    this.color,
    required this.child,
    this.title,
    this.icon,
    this.onPressed,
    this.popOnPressed,
  }) : super(key: key);

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
            onPressed: onPressed,
            icon: const Icon(
              Icons.notifications_none,
              color: WHITE_COLOR,
            ),
          ),
          if (icon == null)
            IconButton(
              onPressed: popOnPressed,
              icon: const Icon(Icons.arrow_back),
            )
        ],
      ),
      drawer: const MainDrawer(),

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: child,
      ),
    );
  }
}
