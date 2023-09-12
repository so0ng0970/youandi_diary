import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youandi_diary/diary/provider/diary_provider.dart';
import 'package:youandi_diary/diary/screen/diary_post_screen.dart';

import '../../common/const/color.dart';
import '../../user/layout/default_layout.dart';

class DiaryDetailScreen extends ConsumerStatefulWidget {
  final String diaryId;
  final String? title;

  const DiaryDetailScreen({
    this.title,
    required this.diaryId,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends ConsumerState<DiaryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.diaryId);
    print(widget.title);
    final diary = ref.read(diaryProvider).getDiaryById(widget.diaryId);
    return DefaultLayout(
      title: widget.title.toString(),
      color: DIARY_DETAIL_COLOR,
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 140,
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: -60,
                      top: -20,
                      child: Image.asset(
                        'asset/image/icon/cloud_icon.png',
                        scale: 5,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        '2023-09-36',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: WHITE_COLOR,
                            letterSpacing: 2.0),
                      ),
                    ),
                    Positioned(
                      right: -45,
                      top: -7,
                      child: Image.asset(
                        'asset/image/icon/love_icon.png',
                        scale: 4,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: const BorderSide(
                          width: 2,
                          color: WHITE_COLOR,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(WRITE_BUTTON),
                  ),
                  onPressed: () {
                    context.go(
                        '/detail/${widget.diaryId}/${DiaryPostScreen.routeName}',
                        extra: {'title': widget.title});
                  },
                  child: const Text(
                    '  글쓰기  ',
                    style: TextStyle(color: DIARY_DETAIL_COLOR),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                height: MediaQuery.of(context).size.height - 150,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: WHITE_COLOR,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(
                    150,
                  ),
                  image: const DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      'asset/image/diary/diary4.jpg',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
