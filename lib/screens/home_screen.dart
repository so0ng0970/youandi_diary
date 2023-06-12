import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youandi_diary/layout/default_layout.dart';
import 'package:youandi_diary/user/model/kakao_login.dart';
import 'package:youandi_diary/user/model/social_view_model.dart';

class HomeScreen extends StatelessWidget {
  final viewModel = SocialViewModel(
    KakaoLogin(),
  );
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      profileImg: '${viewModel.user?.kakaoAccount?.profile?.profileImageUrl}',
      child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Text('${snapshot.hasError}');
            } else {
              return Center(
                child: Column(
                  children: const [
                    Text(
                      '로그인 성공 ',
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
