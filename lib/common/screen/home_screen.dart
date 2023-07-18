import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
            child: ListView(
              shrinkWrap: true, // 스크롤 가능한 영역만 차지하도록 설정
              physics: const NeverScrollableScrollPhysics(), // 스크롤 비활성화
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.end, // 자식 위젯들을 가로 폭 전체로 늘립니다.
                    children: [
                      SizedBox(
                        width: 150, // 버튼의 폭을 30으로 설정합니다.
                        child: ElevatedButton(
                          onPressed: () {
                            _showModalDialog(context);
                          },
                          child: const Text(
                            '다이어리 생성 +',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MaterialButton(
                            textColor: Colors.white,
                            child: Container(
                              height: 200,
                              width: 150,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'asset/image/diary/diary1.jpg'),
                                    fit: BoxFit.cover),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("안녕"),
                              ),
                            ),
                            // ),
                            onPressed: () {
                              print('Tapped');
                            },
                          ),
                          SizedBox(
                            height: 200,
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text(''),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showModalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: 300,
            height: 500,
            color: BACKGROUND_COLOR,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Icon(
                        Icons.close,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: const [
                    Text(
                      '다이어리 만들기',
                      style: TextStyle(
                          fontSize: 30.0,
                          color: WHITE_COLOR,
                          decoration: TextDecoration.none),
                    ),
                    Text(
                      '다이어리 커버 고르기',
                      style: TextStyle(
                        fontSize: 12.0,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
