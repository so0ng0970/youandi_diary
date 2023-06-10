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
    return SignLoginLayout(
      titleText: 'Login',
      child: Form(
        key: _formKey,
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            return Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: '이메일주소',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: '비밀번호',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {},
                  icon: const Icon(Icons.check),
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
                    '회원이 아니신가요?',
                  ),
                ),
                _GoogleButton(
                  onPressed: () async {
                    final google = await signInWithGoogle();
                    if (google != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const HomeScreen();
                          },
                        ),
                      );
                    } else {
                      const Text('실패');
                    }
                  },
                ),
                _KakaoButton(onPressed: () async {
                  await viewModel.logout();
                  setState(() {});
                }),
                const SizedBox(
                  height: 10,
                ),
                Text('${viewModel.isLogined}'),
                if (viewModel.isLogined == true)
                  Image.network(
                      viewModel.user?.kakaoAccount?.profile?.profileImageUrl ?? ''),
                _KakaoButton(onPressed: () async {
                  await viewModel.login();
                  setState(() {});
                }),
              ],
            );
          }
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
