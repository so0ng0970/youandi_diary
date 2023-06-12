import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:youandi_diary/const/color.dart';
import 'package:youandi_diary/layout/button_layout.dart';
import 'package:youandi_diary/layout/sign_login_layout.dart';
import 'package:youandi_diary/screens/home_screen.dart';
import 'package:youandi_diary/screens/sign_page.dart';
import 'package:youandi_diary/user/model/kakao_login.dart';
import 'package:youandi_diary/user/model/social_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final viewModel = SocialViewModel(
    KakaoLogin(),
  );
  final _formKey = GlobalKey<FormState>();
  bool isLoginScreen = true;

  @override
  Widget build(BuildContext context) {
    InputDecoration inputDecoration(
      String hintText,
    ) {
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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: inputDecoration('이메일 주소'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: inputDecoration('비밀번호'),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  _LoginButton(onPressed: () {}),
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
                      final google = await signInWithGoogle();
                      if (google != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return HomeScreen();
                            },
                          ),
                        );
                      } else {
                        const Text('실패');
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _KakaoButton(
                    onPressed: () async {
                      final kakao = await viewModel.login();

                      setState(() {});

                      if (kakao == null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return HomeScreen();
                            },
                          ),
                        );
                      } else {
                        const Text('실패');
                      }
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const SignScreen();
                              },
                            ),
                          );
                        },
                        child: const Text(
                          '회원가입 하러가기',
                          style: TextStyle(
                              color: SIGN_TEXT_COLOR,
                              fontWeight: FontWeight.w600),
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

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

class _LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _LoginButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonLayout(
        bgColor: LOGIN_COLOR,
        textColor: WHITE_COLOR,
        onPressed: onPressed,
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
      imageIcon: 'asset/image/google.png',
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
      imageIcon: 'asset/image/kakao.png',
      buttonText: 'Kakao로 로그인',
    );
  }
}
