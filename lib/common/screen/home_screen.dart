import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:youandi_diary/diary/component/diary_card.dart';
import 'package:youandi_diary/common/component/diary_modal.dart';
import 'package:youandi_diary/common/const/color.dart';
import 'package:youandi_diary/diary/layout/button_dialog_layout.dart';
import 'package:youandi_diary/diary/provider/diary_provider.dart';
import '../../user/layout/default_layout.dart';



class HomeScreen extends ConsumerStatefulWidget {
  static String get routeName => 'home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    // 초기화
    // FlutterLocalNotification.init();

    // 3초 후 권한 요청
    // Future.delayed(
    //   const Duration(seconds: 3),
    //   FlutterLocalNotification.requestNotificationPermission(),
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final diaryList = ref.watch(diaryListProvider).diaryList;
    final diaryDelete = ref.watch(diaryProvider);

    return DefaultLayout(
      color: BGUNDER_COLOR,
      homeScreen: true,
      backBool: false,
      child: CustomScrollView(
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
              ),
            ),
            backgroundColor: BACKGROUND_COLOR,
            expandedHeight: 220,
            centerTitle: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/image/cloud.gif',
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
                      // TextButton(
                      //   onPressed: () =>
                      //       FlutterLocalNotification.showNotification('d', 'd'),
                      //   child: const Text("알림 보내기"),
                      // ),
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
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 20.0,
                          ),
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
                            itemCount: diaryList.length,
                            itemBuilder: (context, index) {
                              final diary = diaryList[index];

                              return Slidable(
                                key: const ValueKey(0),
                                endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ButtonDialogLayout(
                                                    onPressed: () async {
                                                      await diaryDelete
                                                          .deleteDiaryWithSubcollections(
                                                        diaryId: diary.diaryId
                                                            .toString(),
                                                      );

                                                      await diaryDelete
                                                          .removeUserFromDiary(
                                                              diaryId: diary
                                                                  .diaryId
                                                                  .toString());
                                                      context.pop();
                                                    },
                                                    text: '정말 삭제하시겠습니까?');
                                              });
                                        },
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: '삭제',
                                      ),
                                    ]),
                                child: DiaryCard.fromModel(
                                  diaryList: diary,
                                ),
                              );
                            },
                          ),
                        ),
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
    final dialogContext = context;
    showDialog(
      context: dialogContext,
      builder: (BuildContext context) {
        return const DiaryModal();
      },
    );
  }
}
