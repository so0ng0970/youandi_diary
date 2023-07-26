import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youandi_diary/common/component/main_drawer.dart';
import 'package:youandi_diary/common/const/color.dart';
import 'package:youandi_diary/user/model/kakao_login.dart';
import 'package:youandi_diary/user/model/social_view_model.dart';
import 'package:youandi_diary/user/provider/firebase_auth_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static String get routeName => 'home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final viewModel = SocialViewModel(
    KakaoLogin(),
  );

  // List<String> diaryCoverImages = [1, 2, 3, 4]
  //     .map((e) => Text(
  //           'asset/image/diary/diary$e.jpg',
  //         ))
  //     .toList();
  List<String> diaryCoverImages = [
    'asset/image/diary/diary1.jpg',
    'asset/image/diary/diary2.jpg',
    'asset/image/diary/diary3.jpg',
    'asset/image/diary/diary4.jpg',
  ];
  String selectedImage = 'asset/image/diary/diary1.jpg'; // 기본 이미지 설정

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
    ImageCache().clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'asset/image/diary/modal_bg.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            width: 350,
            height: 500,
            child: Padding(
              padding: const EdgeInsets.all(
                10.0,
              ),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // 다이얼로그 닫기
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.blue[800],
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      '다이어리 만들기',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      decoration: const ShapeDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFe6dfd8), Color(0xFFf7f5ec)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 0.4],
                          tileMode: TileMode.clamp,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              50.0,
                            ),
                          ),
                        ),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                50,
                              ),
                            ),
                          ),
                          hintText: '제목',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      '다이어리 커버 고르기',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        color: WHITE_COLOR,
                        width: 430,
                        height: 115,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 100.0,
                              crossAxisSpacing: 8.0,
                            ),
                            itemCount: diaryCoverImages.length,
                            itemBuilder: (context, index) {
                              final imagePath = diaryCoverImages[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedImage = imagePath;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      8.0,
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage(imagePath),
                                      fit: BoxFit.cover,
                                    ),
                                    border: Border.all(
                                      color: selectedImage == imagePath
                                          ? Colors.blue
                                          : Colors.transparent,
                                      width: 3.0,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
