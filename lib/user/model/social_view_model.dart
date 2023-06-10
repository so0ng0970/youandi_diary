import 'package:firebase_auth/firebase_auth.dart';

import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart' as kakao;
import 'package:youandi_diary/user/model/firebase_auth_remote_data_source.dart';
import 'package:youandi_diary/user/model/social_login.dart';

class SocialViewModel {
  final _firebaseAuthDataSource = FirebaseAuthRemoteDataSource();
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
    }
  }

  Future logout() async {
    await _socialLogin.logout();
    isLogined = false;
    user = null;
  }
}
