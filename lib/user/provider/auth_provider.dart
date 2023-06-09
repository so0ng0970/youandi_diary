import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youandi_diary/common/screen/home_screen.dart';
import 'package:youandi_diary/user/screens/sign_screen.dart';

import '../../common/screen/splash_screen.dart';
import '../screens/login_screen.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthProvider({required this.ref});

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
  String? redirectLogic(_, GoRouterState state) {
    final loginIn = state.location == '/login';
    // 유저 상태
    // final firebaseAuth =
    //     FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //   if (user == null) {
    //     loginIn ? null : '/login';
    //   }
    //   loginIn || state.location == '/splash' ? '/' : null;
    // });
    User? user = _firebaseAuth.currentUser;
    // 유저 정보가 없는데
    // 로그인 중이면 그대로 로그인 페이지에 두고
    // 만약에 로그인 중이 아니라면 로그인 페이지로 이동
    if (user == null) {
      return loginIn ? null : '/splash';
    }
    return loginIn || state.location == '/splash' ? '/' : null;

    // 사용자 정보가 있는 상태이므로 리디렉션 필요없음
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
