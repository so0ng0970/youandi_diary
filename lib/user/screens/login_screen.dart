import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youandi_diary/common/const/color.dart';
import 'package:youandi_diary/user/component/custom_email.dart';
import 'package:youandi_diary/user/layout/button_layout.dart';
import 'package:youandi_diary/user/layout/sign_login_layout.dart';
import 'package:youandi_diary/user/model/kakao_login.dart';
import 'package:youandi_diary/user/model/validate.dart';
import 'package:youandi_diary/common/screen/home_screen.dart';
import 'package:youandi_diary/user/screens/sign_screen.dart';

import 'package:youandi_diary/user/model/social_view_model.dart';

class LoginScreen extends StatefulWidget {
  static String get routeName => 'login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final viewModel = LoginSignModel(KakaoLogin());
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode nicknameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  bool isLoginScreen = true;

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  void _removeEmailOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _overlayEntry?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration inputDecoration(String hintText) {
      return InputDecoration(
        hintText: hintText,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: UNDERLINE_INPUT_COLOR,
          ),
        ),
      );
    }

    return SignLoginLayout(
      titleText: 'Login',
      child: Padding(
        padding: const EdgeInsets.only(
          top: 40,
          left: 50,
          right: 50,
          bottom: 10,
        ),
        child: Form(
          key: _formKey,
          child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final isFirebaseUserLoggedIn = snapshot.hasData;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CompositedTransformTarget(
                    link: _layerLink,
                    child: textFormField(
                      key: const ValueKey(1),
                      controller: _emailController,
                      focusNode: emailFocus,
                      validator: (value) =>
                          CheckValidate().validateEmail(emailFocus, value!),
                      keyboardType: TextInputType.emailAddress,
                      hintText: '이메일',
                      onChanged: (_) => {
                        _showEmailOverlay(),
                        _updateEmailOverlay(),
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  textFormField(
                    key: const ValueKey(2),
                    controller: _passwordController,
                    focusNode: passwordFocus,
                    validator: (value) =>
                        CheckValidate().validatePassword(passwordFocus, value!),
                    keyboardType: TextInputType.name,
                    obscureText: true,
                    hintText: '비밀번호',
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  _LoginButton(
                    onPressed: () async {
                      final email = _emailController.text;
                      final password = _passwordController.text;
                      if (email.isNotEmpty && password.isNotEmpty) {
                        try {
                          final credential = EmailAuthProvider.credential(
                            email: email,
                            password: password,
                          );
                          await FirebaseAuth.instance
                              .signInWithCredential(credential);
                          await saveTokenToDatabase(
                              FirebaseAuth.instance.currentUser!.uid);

                          context.goNamed(
                            HomeScreen.routeName,
                          );
                        } on FirebaseAuthException catch (e) {
                          print(e);
                          if (e.code == 'user-not-found') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('등록되지 않은 이메일입니다'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else if (e.code == 'wrong-password') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('비밀번호가 틀렸습니다'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            SnackBar(
                              content: Text(e.code),
                              backgroundColor: Colors.green,
                            );
                          }
                        }
                      } else {
                        print('오류가 발생했습니다 ');
                      }
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    child: Center(
                      child: Text(
                        'Or',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: WHITE_COLOR,
                        ),
                      ),
                    ),
                  ),
                  _GoogleButton(
                    onPressed: () async {
                      final google =
                          await LoginSignModel(null).signInWithGoogle();
                      await saveTokenToDatabase(
                          FirebaseAuth.instance.currentUser!.uid);
                      if (google != null) {
                        context.goNamed(
                          HomeScreen.routeName,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('구글 로그인에 실패했습니다.'),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _KakaoButton(
                    onPressed: () async {
                      await viewModel.login(context);
                      setState(() {});
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '회원이 아니신가요?',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.pushNamed(
                            SignScreen.routeName,
                          );
                        },
                        child: const Text(
                          '회원가입 하러가기',
                          style: TextStyle(
                            color: SIGN_TEXT_COLOR,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showEmailOverlay() {
    if (emailFocus.hasFocus) {
      if (_emailController.text.isNotEmpty) {
        final email = _emailController.text;

        if (!email.contains('@')) {
          if (_overlayEntry == null) {
            _overlayEntry = _emailListOverlayEntry();
            Overlay.of(context).insert(_overlayEntry!);
          }
        } else {
          _removeEmailOverlay();
        }
      } else {
        _removeEmailOverlay();
      }
    }
  }

  // 이메일 자동 입력창
  OverlayEntry _emailListOverlayEntry() {
    return customDropdown.emailRecommendation(
      width: MediaQuery.of(context).size.width - 100,
      layerLink: _layerLink,
      controller: _emailController,
      onPressed: () {
        setState(() {
          emailFocus.unfocus();
          _removeEmailOverlay();
        });
      },
    );
  }

  void _updateEmailOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  Future<void> saveTokenToDatabase(String userId) async {
    // Get the token for this device
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = FirebaseFirestore.instance.collection('user').doc(userId);

      try {
        await tokens.set({
          'pushToken': fcmToken,
        }, SetOptions(merge: true));
      } catch (e) {
        print("Failed to write FCM token to Firestore: $e");
      }
    }
  }
}

class _LoginButton extends StatelessWidget {
  final Future<void> Function()? onPressed;
  const _LoginButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonLayout(
        bgColor: LOGIN_COLOR,
        textColor: WHITE_COLOR,
        onPressed: onPressed != null ? () => onPressed!() : () {},
        buttonText: '로그인');
  }
}

class _GoogleButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _GoogleButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonLayout(
      bgColor: GOOGLE_COLOR,
      textColor: const Color.fromARGB(255, 1, 64, 119),
      onPressed: onPressed,
      imageIcon: 'assets/image/google.png',
      buttonText: 'Google로 로그인',
    );
  }
}

class _KakaoButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _KakaoButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ButtonLayout(
      textColor: Colors.brown[700]!,
      bgColor: KAKAOTALK_COLOR,
      onPressed: onPressed,
      imageIcon: 'assets/image/kakao.png',
      buttonText: 'Kakao로 로그인',
    );
  }
}
