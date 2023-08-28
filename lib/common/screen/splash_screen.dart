import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youandi_diary/common/screen/home_screen.dart';
import 'package:youandi_diary/user/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  static String get routeName => 'splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      checkAuthStatus();
    });
  }

  Future<void> checkAuthStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Firebase에 로그인된 사용자가 있으면 HomeScreen으로 이동
      context.goNamed(HomeScreen.routeName);
    } else {
      // Firebase에 로그인된 사용자가 없으면 LoginPage로 이동
      context.goNamed(LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/image/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
