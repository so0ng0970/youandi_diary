import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youandi_diary/user/model/kakao_login.dart';
import 'package:youandi_diary/user/model/social_view_model.dart';

class MainDrawer extends StatelessWidget {
  final String profileImg;
  final String nickName;
  final String email;
  const MainDrawer(
      {required this.profileImg,
      required this.nickName,
      required this.email,
      super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = SocialViewModel(
      KakaoLogin(),
    );
    return Drawer(
      child: ListView(
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF9fc5e8),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(45.0),
                  bottomRight: Radius.circular(45.0),
                ),
              ),
              currentAccountPicture: CircleAvatar(
                // 현재 계정 이미지 set
                backgroundImage: NetworkImage(
                  profileImg,
                ),
              ),
              accountName: Text(
                nickName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                email,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: const Text(
              '로그아웃',
            ),
          )
        ],
      ),
    );
  }
}
