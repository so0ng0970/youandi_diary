import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletons/skeletons.dart';
import 'package:youandi_diary/common/component/diary_modal.dart';
import 'package:youandi_diary/common/component/main_drawer.dart';
import 'package:youandi_diary/common/const/color.dart';
import 'package:youandi_diary/common/utils/data_utils.dart';
import 'package:youandi_diary/diary/model/diary_model.dart';
import 'package:youandi_diary/diary/provider/diary_provider.dart';

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
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: BGUNDER_COLOR,
      drawer: const MainDrawer(),
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
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MODAL_BUTTON_COLOR,
                          ),
                          onPressed: _showDiaryModal,
                          child: const Text(
                            '다이어리 생성 +',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (user == null)
                        const Text(
                          'd',
                        ),
                      if (user != null)
                        FutureBuilder<List<DiaryModel>>(
                          future: _getDiaryListFuture(ref),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SkeletonAvatar();
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
                                        print(
                                          '/detail/${diary.diaryId}',
                                        );
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
                                              const Spacer(),
                                              Center(
                                                child: Text(
                                                  DataUtils.getTimeFromDateTime(
                                                          dateTime:
                                                              diary.dataTime)
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color: WHITE_COLOR,
                                                  ),
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
              ],
            ),
          ),
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
