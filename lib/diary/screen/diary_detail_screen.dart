import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youandi_diary/diary/provider/diary_provider.dart';

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
      title: widget.title,
      child: Container(
        decoration: const BoxDecoration(
          color: DIARY_DETAIL_COLOR,
        ),
        child: Container(
            decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(
              50,
            ),
          ),
          image: DecorationImage(
            scale: 2.1,
            image: AssetImage('asset/image/diary/diary4.jpg'),
            
          ),
        )),
      ),
    );
  }
}
