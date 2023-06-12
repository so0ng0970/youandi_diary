import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youandi_diary/const/color.dart';
import 'package:youandi_diary/layout/button_layout.dart';
import 'package:youandi_diary/layout/sign_login_layout.dart';
import 'package:youandi_diary/models/validate.dart';
import 'package:youandi_diary/screens/login_page.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});

  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  final _authentication = FirebaseAuth.instance;
  final FocusNode nicknameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  String userName = '';
  String userEmail = '';
  String userPassword = '';

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
      appBar: AppBar(
        toolbarHeight: 30,
        backgroundColor: Colors.blue[100],
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          iconSize: 20,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      titleText: 'Sign',
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 40,
            left: 50,
            right: 50,
          ),
          child: Column(
            children: [
              TextFormField(
                key: const ValueKey(1),
                focusNode: nicknameFocus,
                validator: (value) =>
                    CheckValidate().validateNickName(nicknameFocus, value!),
                keyboardType: TextInputType.name,
                onSaved: (value) {
                  userName = value!;
                },
                onChanged: (value) {
                  userName = value;
                },
                decoration: inputDecoration('닉네임'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                key: const ValueKey(2),
                focusNode: emailFocus,
                validator: (value) =>
                    CheckValidate().validateEmail(emailFocus, value!),
                keyboardType: TextInputType.emailAddress,
                onSaved: (newValue) {
                  userEmail = newValue!;
                },
                onChanged: (value) {
                  userEmail = value;
                },
                decoration: inputDecoration('이메일'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                key: const ValueKey(3),
                focusNode: passwordFocus,
                validator: (value) =>
                    CheckValidate().validatePassword(passwordFocus, value!),
                keyboardType: TextInputType.name,
                onSaved: (value) {
                  userPassword = value!;
                },
                onChanged: (String value) {
                  userPassword = value;
                },
                decoration: inputDecoration('비밀번호'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: inputDecoration('비밀번호(확인)'),
              ),
              const SizedBox(
                height: 50,
              ),
              _SignButton(
                onPressed: () async {
                  formKey.currentState?.validate();
                  try {
                    final newUser =
                        await _authentication.createUserWithEmailAndPassword(
                      email: userEmail,
                      password: userPassword,
                    );
                    await FirebaseFirestore.instance
                        .collection('user')
                        .doc(newUser.user!.uid)
                        .set({
                      'userName': userEmail,
                      'email': userEmail,
                    });
                    if (newUser.user != null) {
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const LoginPage();
                          },
                        ),
                      );
                    }
                  } catch (e) {
                    print(e);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please check your email and password'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SignButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _SignButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonLayout(
        bgColor: SIGN_TEXT_COLOR,
        textColor: WHITE_COLOR,
        onPressed: () {},
        buttonText: '회원가입');
  }
}
