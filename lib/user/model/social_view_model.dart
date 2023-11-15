import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  LoginSignModel(this._socialLogin);

  Future login(BuildContext context) async {
    isLogined = await _socialLogin!.login();
    if (isLogined) {
      user = await kakao.UserApi.instance.me();

      final userInfo = {
        'uid': user!.id.toString(),
        'displayName': user!.kakaoAccount!.profile!.nickname,
        'email': user!.kakaoAccount!.email!,
        'photoURL': user!.kakaoAccount!.profile!.profileImageUrl!,
      };

      final token = await _firebaseAuthDataSource.createCustomToken(userInfo);

      await FirebaseAuth.instance.signInWithCustomToken(token);
      await saveUserFirestore(userInfo);
      await navigateToHomeScreen(context);
    }
  }

  Future<void> navigateToHomeScreen(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const HomeScreen();
        },
      ),
    );
  }

  Future<void> registerUser(
    BuildContext context,
    bool mounted,
    TextEditingController nicknameFocusController,
    TextEditingController emailFocusController,
    TextEditingController passwordFocusController,
  ) async {
    final authentication = FirebaseAuth.instance;
    final firebaseStorage = FirebaseStorage.instance;
    final ref = firebaseStorage.ref().child('user/profile.jpg');

    String photoUrl = await ref.getDownloadURL();

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    formKey.currentState?.validate();
    try {
      final newUser = await authentication.createUserWithEmailAndPassword(
        email: emailFocusController.text,
        password: passwordFocusController.text,
      );
      String displayName = nicknameFocusController.text;

      await newUser.user?.updateProfile(displayName: displayName);
      if (isProvidedByGoogle(authentication)) {
        photoUrl = authentication.currentUser!.photoURL!;
      }

      final userData = {
        'photoUrl': photoUrl,
        'userName': displayName,
        'email': emailFocusController.text,
        'uid': newUser.user!.uid
      };

      await FirebaseFirestore.instance
          .collection('user')
          .doc(newUser.user!.uid)
          .set(userData);

      navigateToLoginScreen(context);
    } catch (e) {
      handleRegistrationError(context, mounted, e);
    }
  }

  bool isProvidedByGoogle(FirebaseAuth authentication) {
    return authentication.currentUser!.providerData
            .any((userInfo) => userInfo.providerId == 'google.com') &&
        authentication.currentUser!.photoURL != null;
  }

  void handleRegistrationError(BuildContext context, bool mounted, dynamic e) {
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

  Future<void> navigateToLoginScreen(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const LoginScreen();
        },
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final docRef = FirebaseFirestore.instance
        .collection('user')
        .doc(userCredential.user?.uid);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      // Firestore에 사용자 정보가 없으면, 새로 저장합니다.
      await saveUserFirestore({
        'userName': userCredential.user?.displayName ?? '',
        'email': userCredential.user?.email ?? '',
        'photoUrl': userCredential.user?.photoURL ?? '',
        'uid': userCredential.user?.uid ?? '',
      });
    } else {
      // Firestore에 사용자 정보가 있으면, 그 정보를 사용합니다.
      final userData = docSnapshot.data();
      // ignore: deprecated_member_use
      userCredential.user?.updateProfile(
        displayName: userData?['userName'],
        photoURL: userData?['photoUrl'],
      );
    }

    return userCredential;
  }

  Future logout() async {
    await _socialLogin!.logout();
    isLogined = false;
    user = null;
  }

  Future<void> saveUserFirestore(Map<String, dynamic> userData) async {
    final user = _authentication.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .set(userData, SetOptions(merge: true));
    }
  }
}

abstract class SocialLogin {
  Future<bool> login();
  Future<bool> logout();
}
