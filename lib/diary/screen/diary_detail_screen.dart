import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/const/color.dart';
import '../../user/layout/default_layout.dart';

class DiaryDetailScreen extends ConsumerStatefulWidget {
  const DiaryDetailScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends ConsumerState<DiaryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'd',
      child: Container(
        decoration: const BoxDecoration(
          color: DIARY_DETAIL_COLOR,
        ),
      ),
    );
  }
}
