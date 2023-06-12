import 'package:flutter/material.dart';
import 'package:youandi_diary/user/model/kakao_login.dart';
import 'package:youandi_diary/user/model/social_view_model.dart';

class MainDrawer extends StatelessWidget {
  final String profileImg;
  const MainDrawer({required this.profileImg, super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = SocialViewModel(
      KakaoLogin(),
    );
    return Drawer(
      backgroundColor: Colors.amber,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              // 현재 계정 이미지 set
              backgroundImage: NetworkImage(
                profileImg,
              ),
            ),
            accountName: const Text('soonger'),
            accountEmail: const Text('soonger'),
          )
        ],
      ),
    );
  }
}
