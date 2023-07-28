import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youandi_diary/common/component/diary_modal.dart';
import 'package:youandi_diary/common/component/main_drawer.dart';
import 'package:youandi_diary/common/const/color.dart';
import 'package:youandi_diary/user/provider/firebase_auth_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static String get routeName => 'home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(firebase_auth_Provider);

    return Scaffold(
      backgroundColor: HOMESCREEN_COLOR,
      drawer: authState.when(
        data: (user) {
          if (user == null) {
            return const Text('Not authenticated');
          } else {
            return MainDrawer(
              profileImg: user.photoURL ?? '',
              nickName: user.displayName ?? '',
              email: user.email ?? '',
            );
          }
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => Text('Error: $error'),
      ),
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
                          onPressed: _showDiaryModal, // 다이어리 모달 띄우기
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
                                    'asset/image/diary/diary1.jpg',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("안녕"),
                              ),
                            ),
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

  void _showDiaryModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DiaryModal();
      },
    );
  }
}
