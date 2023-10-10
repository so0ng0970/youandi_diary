import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youandi_diary/user/model/kakao_login.dart';
import 'package:youandi_diary/user/model/social_view_model.dart';
import 'package:youandi_diary/user/provider/auth_provider.dart';
import 'package:youandi_diary/user/provider/user_provider.dart';
import 'package:youandi_diary/user/screens/user_profile_screen.dart';

import '../../user/provider/firebase_auth_provider.dart';
import '../../user/provider/profile_user_provider.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userGetProvider);
    final authState = ref.watch(firebase_auth_Provider);
    final provider = ref.read(authProvider);
    final viewModel = LoginSignModel(
      KakaoLogin(),
    );

    TextButton textButton(VoidCallback onpressed, Text text) {
      return TextButton(onPressed: onpressed, child: text);
    }

    return Drawer(
      child: ListView(
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: userData.when(
              data: (user) {
                if (user == null) {
                  return const Text('Not authenticated');
                } else {
                  return Stack(
                    children: [
                      UserAccountsDrawerHeader(
                        decoration: const BoxDecoration(
                          color: Color(0xFF9fc5e8),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(45.0),
                            bottomRight: Radius.circular(45.0),
                          ),
                        ),
                        currentAccountPicture: CircleAvatar(
                          // 현재 계정 이미지 set
                          backgroundImage: selectImage(imageUrl: user.photoUrl),
                        ),
                        accountName: Text(
                          user.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        accountEmail: Text(
                          user.email ?? '',
                        ),
                      ),
                      Positioned(
                        left: 55,
                        child: IconButton(
                          onPressed: () {
                            context.pushNamed(UserProfileScreen.routeName);
                          },
                          icon: const Icon(
                            Icons.settings,
                            size: 25,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  );
                }
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => Text('Error: $error'),
            ),
          ),
          textButton(
            () {
              provider.logout(context);
            },
            const Text(
              '로그아웃',
            ),
          ),
          textButton(
            () {
              context.pushNamed(UserProfileScreen.routeName);
            },
            const Text(
              '프로필 수정',
            ),
          )
        ],
      ),
    );
  }
}
