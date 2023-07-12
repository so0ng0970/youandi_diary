import 'package:flutter/material.dart';
import 'package:youandi_diary/common/const/color.dart';
import 'package:youandi_diary/user/layout/default_layout.dart';
import 'package:youandi_diary/user/model/kakao_login.dart';
import 'package:youandi_diary/user/model/social_view_model.dart';

class HomeScreen extends StatelessWidget {
  static String get routeName => 'home';

  final viewModel = SocialViewModel(
    KakaoLogin(),
  );
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Container(
        color: BACKGROUND_COLOR,
        child: Center(
          child: Column(
            children: const [
              Text(
                '로그인 성공 ',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
