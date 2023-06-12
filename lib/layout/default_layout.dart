import 'package:flutter/material.dart';
import 'package:youandi_diary/component/main_drawer.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final String profileImg;
  const DefaultLayout(
      {required this.child, required this.profileImg, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      drawer: MainDrawer(profileImg: profileImg),
      body: child,
    );
  }

  AppBar? appbar() {
    return AppBar();
  }
}
