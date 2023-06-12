import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart' as kakao;
import 'package:youandi_diary/user/model/firebase_auth_remote_data_source.dart';
import 'package:youandi_diary/user/model/social_login.dart';

class SocialViewModel {
  final _firebaseAuthDataSource = FirebaseAuthRemoteDataSource();
  final _authentication = FirebaseAuth.instance;
  final SocialLogin _socialLogin;
  bool isLogined = false;
  kakao.User? user;
  SocialViewModel(this._socialLogin);

  Future login() async {
    isLogined = await _socialLogin.login();
    if (isLogined) {
      user = await kakao.UserApi.instance.me();

      final token = await _firebaseAuthDataSource.createCustomToken(
        {
          'uid': user!.id.toString(),
          'displayName': user!.kakaoAccount!.profile!.nickname,
          'email': user!.kakaoAccount!.email!,
          'photoURL': user!.kakaoAccount!.profile!.profileImageUrl!,
        },
      );

      await FirebaseAuth.instance.signInWithCustomToken(token);
      try {
        // 이미 등록된 이메일 주소로 로그인
        await _authentication.signInWithEmailAndPassword(
          email: user!.kakaoAccount!.email!,
          password: user!.kakaoAccount!.profile!.profileImageUrl!,
        );
      } catch (e) {
        print('Failed to sign in with existing email: $e');
        // 로그인 실패 처리
        return;
      }

      // 로그인에 성공한 경우, 기존 사용자 정보에 액세스할 수 있습니다.

      // Firestore에 데이터 저장
      try {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(_authentication.currentUser!.uid)
            .set({
          // 저장할 데이터
          'displayName': user!.kakaoAccount!.profile!.nickname,
          'email': user!.kakaoAccount!.email!,
          'photoURL': user!.kakaoAccount!.profile!.profileImageUrl!,
        });
        print('Data saved to Firestore');
      } catch (e) {
        print('Failed to save data to Firestore: $e');
      }
    }
  }

  Future logout() async {
    await _socialLogin.logout();
    isLogined = false;
    user = null;
  }
}
