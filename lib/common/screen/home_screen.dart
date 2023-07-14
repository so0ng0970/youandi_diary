import 'package:flutter/material.dart';
import 'package:youandi_diary/common/const/color.dart';
import 'package:youandi_diary/user/model/kakao_login.dart';
import 'package:youandi_diary/user/model/social_view_model.dart';

class HomeScreen extends StatelessWidget {
  static String get routeName => 'home';

  final viewModel = SocialViewModel(
    KakaoLogin(),
  );

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HOMESCREEN_COLOR,
      // drawer: MainDrawer(
      //   profileImg: profileImg,
      //   nickName: nickName,
      //   email: email,
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(
                  50,
                ),
                bottomRight: Radius.circular(
                  50,
                ),
              ), //모서리
            ), //테두리
            backgroundColor: BACKGROUND_COLOR,
            expandedHeight: 250,
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'asset/image/cloud.gif',
                scale: 2.0,
              ),
              title: const Text('Let\'s keep a record !'),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              child: ListView(
                shrinkWrap: true, // 스크롤 가능한 영역만 차지하도록 설정
                physics: const NeverScrollableScrollPhysics(), // 스크롤 비활성화
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text(''),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
