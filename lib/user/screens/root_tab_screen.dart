import 'package:flutter/material.dart';
import 'package:youandi_diary/common/const/color.dart';
import 'package:youandi_diary/user/component/post_list.dart';
import 'package:youandi_diary/user/component/user_profile.dart';

import '../component/comment_list.dart';

class RootTabScreen extends StatefulWidget {
  static String get routeName => '/root';
  const RootTabScreen({super.key});

  @override
  State<RootTabScreen> createState() => _RootTabScreenState();
}

class _RootTabScreenState extends State<RootTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int index = 0;
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    controller.addListener(() {
      tabListener();
    });
  }

  @override
  void dispose() {
    controller.removeListener(() {
      tabListener();
    });
    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: PRFBG,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: TabBarView(
        controller: controller,
        children: const [
          UserProfile(),
          PostList(),
          CommentList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: POSTLIST,
        unselectedLabelStyle: const TextStyle(
          color: POSTLIST,
        ),
        selectedItemColor: PRFCHECK,
        selectedLabelStyle: const TextStyle(
          color: PRFCHECK,
        ),
        selectedFontSize: 14,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.shifting,
        onTap: (int index) {
          controller.animateTo(index);
        },
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
            ),
            label: '내 프로필 ',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.description,
            ),
            label: '내가 쓴 글 목록',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.short_text,
            ),
            label: '내가 쓴 댓글 목록',
          )
        ],
      ),
    );
  }
}
