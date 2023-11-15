// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:youandi_diary/common/component/diary_modal.dart';
import 'package:youandi_diary/common/screen/home_screen.dart';
import 'package:youandi_diary/diary/component/calendar.dart';
import 'package:youandi_diary/diary/screen/diary_detail_screen.dart';
import 'package:youandi_diary/diary/screen/diary_post_screen.dart';
import 'package:youandi_diary/user/screens/sign_screen.dart';

import '../../common/screen/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/root_tab_screen.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthProvider({
    required this.ref,
  });

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
          path: '/root',
          name: RootTabScreen.routeName,
          builder: (context, state) => const RootTabScreen(),
        ),
        GoRoute(
          path: '/',
          name: HomeScreen.routeName,
          builder: (context, state) => const HomeScreen(),
          routes: [
            GoRoute(
              path: 'diaryModal',
              name: DiaryModal.routeName,
              builder: (context, state) => const DiaryModal(),
            ),
            GoRoute(
                path: 'detail/:rid',
                builder: (context, state) {
                  final title = (state.extra as Map<String, dynamic>?)?['title']
                      ?.toString();
                  final diaryId = state.pathParameters['rid'];

                  return DiaryDetailScreen(
                    diaryId: diaryId.toString(),
                    title: title,
                  );
                },
                routes: [
                  GoRoute(
                    path: 'calendar',
                    name: Calendar.routeName,
                    builder: (context, state) {
                      final diaryId = state.pathParameters['rid'].toString();

                      return Calendar(
                        diaryId: diaryId,
                      );
                    },
                  ),
                  GoRoute(
                      path: ':post',
                      name: DiaryPostScreen.routeName,
                      builder: (context, state) {
                        final selectedDayString = (state.extra
                                as Map<String, dynamic>?)?['selectedDay']
                            ?.toString();
                        final selectedDay = selectedDayString != null
                            ? DateTime.parse(selectedDayString)
                            : DateTime.now();
                        final diaryId = state.pathParameters['rid'].toString();
                        final diaryTitle =
                            (state.extra as Map<String, dynamic>?)?['title']
                                ?.toString();

                        return DiaryPostScreen(
                          edit: false,
                          selectedDay: selectedDay,
                          diaryId: diaryId,
                          diaryTitle: diaryTitle.toString(),
                        );
                      }),
                ]),
          ],
        )
      ];
  String? redirectLogic(_, GoRouterState state) {
    final loginIn = state.location == '/login';

    final splashPage = state.location == '/splash';
    final signPage = state.location == '/sign';
    // 유저 상태

    User? user = _firebaseAuth.currentUser;
    // 유저 정보가 없는데
    // 로그인 중이면 그대로 로그인 페이지에 두고
    // 만약에 로그인 중이 아니라면 로그인 페이지로 이동
    if (user == null) {
      return loginIn || splashPage || signPage ? null : '/login';
    }
    return loginIn || state.location == '/splash' ? '/' : null;

    // 사용자 정보가 있는 상태이므로 리디렉션 필요없음
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    notifyListeners();
  }
}
