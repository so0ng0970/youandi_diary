import 'package:flutter/material.dart';
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Image.asset(
                  'asset/image/cloud.gif',
                ),
              ),
            ),
          ),
          // SliverToBoxAdapter(
          //   child: DefaultLayout(
          //     appBar: null, // 빈 appBar 사용
          //     child: Container(
          //       color: BACKGROUND_COLOR,
          //       child: ListView(
          //         shrinkWrap: true, // 스크롤 가능한 영역만 차지하도록 설정
          //         physics: const NeverScrollableScrollPhysics(), // 스크롤 비활성화
          //         children: [
          //           OutlinedButton(
          //             onPressed: () {},
          //             child: const Text(''),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
