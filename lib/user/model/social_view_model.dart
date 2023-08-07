import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart' as kakao;
import 'package:youandi_diary/common/screen/home_screen.dart';
import 'package:youandi_diary/user/model/firebase_auth_remote_data_source.dart';
import 'package:youandi_diary/user/screens/login_screen.dart';

class LoginSignModel {
  final _firebaseAuthDataSource = FirebaseAuthRemoteDataSource();
  final _authentication = FirebaseAuth.instance;
  final SocialLogin? _socialLogin;
  bool isLogined = false;
  kakao.User? user;

  LoginSignModel(
    this._socialLogin,
  );

  Future login(BuildContext context) async {
    isLogined = await _socialLogin!.login();
    if (isLogined) {
      user = await kakao.UserApi.instance.me();

      final token = await _firebaseAuthDataSource.createCustomToken({
        'uid': user!.id.toString(),
        'displayName': user!.kakaoAccount!.profile!.nickname,
        'email': user!.kakaoAccount!.email!,
        'photoURL': user!.kakaoAccount!.profile!.profileImageUrl!,
      });

      await FirebaseAuth.instance.signInWithCustomToken(token);
      try {
        // 이미 등록된 이메일 주소로 로그인
        await _authentication.signInWithEmailAndPassword(
          email: user!.kakaoAccount!.email!,
          password: user!.kakaoAccount!.profile!.profileImageUrl!,
        );

        await FirebaseFirestore.instance
            .collection('user')
            .doc(_authentication.currentUser!.uid)
            .set({
          'displayName': user!.kakaoAccount!.profile!.nickname,
          'email': user!.kakaoAccount!.email!,
          'photoURL': user!.kakaoAccount!.profile!.profileImageUrl!,
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const HomeScreen();
            },
          ),
        );
      } catch (e) {
        print('Failed to sign in with existing email: $e');
        // 로그인 실패 처리
        return;
      }
    }
  }

  Future<void> registerUser(
    BuildContext context,
    bool mounted,
    TextEditingController nicknameFocusController,
    TextEditingController emailFocusController,
    TextEditingController passwordFocusController,
  ) async {
    final authentication = FirebaseAuth.instance;

    String photoUrl = 'asset/image/diary/profile.jpg';

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    formKey.currentState?.validate();
    try {
      final newUser = await authentication.createUserWithEmailAndPassword(
        email: emailFocusController.text,
        password: passwordFocusController.text,
      );
      if (authentication.currentUser!.providerData
              .any((userInfo) => userInfo.providerId == 'google.com') &&
          authentication.currentUser!.photoURL != null) {
        photoUrl = authentication.currentUser!.photoURL!;
      }
      await FirebaseFirestore.instance
          .collection('user')
          .doc(newUser.user!.uid)
          .set({
        'photoUrl': photoUrl,
        'userName': nicknameFocusController.text,
        'email': emailFocusController.text,
      });
      if (newUser.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const LoginScreen();
            },
          ),
        );
      }
    } catch (e) {
      print(e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('이메일과 비밀번호를 확인해주세요'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future logout() async {
    await _socialLogin!.logout();
    isLogined = false;
    user = null;
  }
}

abstract class SocialLogin {
  Future<bool> login();
  Future<bool> logout();
}
