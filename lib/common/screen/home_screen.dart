import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youandi_diary/common/component/diary_modal.dart';
import 'package:youandi_diary/common/component/main_drawer.dart';
import 'package:youandi_diary/common/const/color.dart';
import 'package:youandi_diary/diary/model/diary_model.dart';
import 'package:youandi_diary/diary/provider/diary_provider.dart';
import 'package:youandi_diary/user/provider/firebase_auth_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static String get routeName => 'home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

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
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.end, // 자식 위젯들을 가로 폭 전체로 늘립니다.
                children: [
                  const SizedBox(
                    height: 10,
                  ),
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
                    height: 10,
                  ),
                  FutureBuilder<List<DiaryModel>>(
                    future: _getDiaryListFuture(ref),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 4 / 5.3,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 20,
                            ),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final diary = snapshot.data![index];
                              return GestureDetector(
                                onTap: () {
                                  context.go(
                                    '/detail/${diary.diaryId}',
                                  );
                                  print('${diary.diaryId}');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        diary.coverImg,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          diary.title,
                                          style: const TextStyle(
                                            fontSize: 30,
                                            color: WHITE_COLOR,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          '작성자: ${diary.member.map((e) => e.userName).toList().join(',')}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: WHITE_COLOR,
                                          ),
                                        ),
                                        Text(
                                          diary.dataTime,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: WHITE_COLOR,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const Text('No data');
                      }
                    },
                  ),
                ],
              ),
            ),
          ])),
        ],
      ),
    );
  }

  Future<List<DiaryModel>> _getDiaryListFuture(WidgetRef ref) async {
    await Future.delayed(Duration.zero);
    return ref.watch(diaryListProvider).diaryList;
  }

  void _showDiaryModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const DiaryModal();
      },
    );
  }
}
