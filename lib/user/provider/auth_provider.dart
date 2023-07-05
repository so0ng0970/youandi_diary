import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youandi_diary/common/screen/home_screen.dart';
import 'package:youandi_diary/user/screens/sign_screen.dart';

import '../../common/screen/splash_screen.dart';
import '../screens/login_screen.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});

class AuthProvider extends ChangeNotifier {
  List<GoRoute> get routes => [
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/sign',
          name: SignScreen.routeName,
          builder: (context, state) => const SignScreen(),
        ),
        GoRoute(
          path: '/',
          name: HomeScreen.routeName,
          builder: (context, state) => HomeScreen(),
        )
      ];

  void logout() {
    // ref.read(userMeProvider.notifier).logout();
    notifyListeners();
  }

// // splaxh Screen
// // 앱을 처음 시작했을때
// // 토큰이 존재하는지 확인하고
// // login 스크린 아니면 홈 스크린 으로 보낼지 확인
//   String? redirectLogic(_, GoRouterState state) {
//     final loginIn = state.location == '/login';
//     // 유저 상태
//     final UserModelBase? user = ref.read(userMeProvider);
//     // 유저 정보가 없는데
//     // 로그인 중이면 그대로 로그인 페이지에 두고
//     // 만약에 로그인 중이 아니라면 로그인 페이지로 이동
//     if (user == null) {
//       return loginIn ? null : '/login';
//     }

//     // user != null

//     // UserModel
//     // 사용자 정보가 있는 상태면
//     // 로그인 중이거나 현재 위치가 splashScreen
//     // 홈으로 이동
//     if (user is UserModel) {
//       return loginIn || state.location == '/splash' ? '/' : null;
//     }

//     // userModelError
//     if (user is UserModelError) {
//       return !loginIn ? '/login' : null;
//     }
//     return null;
//   }
}
