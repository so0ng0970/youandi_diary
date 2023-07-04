import 'package:flutter/material.dart';
import 'package:youandi_diary/user/model/kakao_login.dart';
import 'package:youandi_diary/user/model/social_view_model.dart';

class MainDrawer extends StatelessWidget {
  final String profileImg;
  final String nickName;
  const MainDrawer(
      {required this.profileImg, required this.nickName, super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = SocialViewModel(
      KakaoLogin(),
    );
    return Drawer(
      backgroundColor: Colors.blue,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 120, 149, 159),
            ),
            currentAccountPicture: CircleAvatar(
              // 현재 계정 이미지 set
              backgroundImage: NetworkImage(
                profileImg,
              ),
            ),
            accountName: Text(nickName),
            accountEmail: null,
          )
        ],
      ),
    );
  }
}
