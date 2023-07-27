import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youandi_diary/common/const/color.dart';

import '../../user/provider/firebase_auth_provider.dart';

class DiaryModal extends ConsumerStatefulWidget {
  static String get routeName => 'diaryModal';
  const DiaryModal({Key? key}) : super(key: key);

  @override
  ConsumerState<DiaryModal> createState() => _DiaryModalState();
}

class _DiaryModalState extends ConsumerState<DiaryModal> {
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
                      colors: [
                        Color(0xFFe6dfd8),
                        Color(
                          0xFFf7f5ec,
                        ),
                      ],
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
                const SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // 사용자 프로필 이미지 표시
                        authState.when(
                          data: (user) {
                            if (user != null) {
                              return CircleAvatar(
                                backgroundColor: Colors.blue[900],
                                radius: 32,
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                    user.photoURL ?? '',
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox(); // 유저 데이터가 없을 경우 빈 SizedBox를 반환하거나 다른 대체 위젯을 사용할 수 있습니다.
                            }
                          },
                          loading: () =>
                              const CircularProgressIndicator(), // 로딩 중일 때 표시할 위젯
                          error: (error, stackTrace) =>
                              Text('Error: $error'), // 에러 발생 시 표시할 위젯
                        ),
                        // 친구 추가 버튼 추가

                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                          ),
                          child: DottedBorder(
                            padding: const EdgeInsets.all(7),
                            borderType: BorderType.Circle,
                            color: Colors.black,
                            strokeWidth: 1,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.add,
                                size: 30.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
