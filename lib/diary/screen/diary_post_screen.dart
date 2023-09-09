import 'package:flutter/widgets.dart';
import 'package:youandi_diary/user/layout/default_layout.dart';

import '../../common/const/color.dart';

class DiaryPostScreen extends StatelessWidget {
  static String get routeName => 'post';
  const DiaryPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      color: DIARY_DETAIL_COLOR,
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  print('d');
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width - 70,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: WHITE_COLOR,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(
                      50,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'asset/image/icon/photo.png',
                        scale: 3,
                      ),
                      const Text(
                        'add photo & video +',
                        style: TextStyle(
                          color: WHITE_COLOR,
                          fontSize: 20,
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
    );
  }
}
