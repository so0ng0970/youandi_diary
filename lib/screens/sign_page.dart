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
  final TextEditingController nicknameFocusController = TextEditingController();
  final TextEditingController emailFocusController = TextEditingController();
  final TextEditingController passwordFocusController = TextEditingController();
  String photoUrl = '';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  Future<void> registerUser() async {
    formKey.currentState?.validate();
    try {
      final newUser = await _authentication.createUserWithEmailAndPassword(
        email: emailFocusController.text,
        password: passwordFocusController.text,
      );
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
            content: Text('이메일과 비밀번호를 확인해주세요'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    nicknameFocusController.dispose();
    emailFocusController.dispose();
    passwordFocusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      titleText: '회원가입',
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 40,
            left: 50,
            right: 50,
            bottom: 10,
          ),
          child: Column(
            children: [
              TextFormField(
                key: const ValueKey(1),
                controller: nicknameFocusController,
                focusNode: nicknameFocus,
                validator: (value) =>
                    CheckValidate().validateNickName(nicknameFocus, value!),
                keyboardType: TextInputType.name,
                decoration: inputDecoration('닉네임'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                key: const ValueKey(2),
                controller: emailFocusController,
                focusNode: emailFocus,
                validator: (value) =>
                    CheckValidate().validateEmail(emailFocus, value!),
                keyboardType: TextInputType.emailAddress,
                decoration: inputDecoration('이메일'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                key: const ValueKey(3),
                controller: passwordFocusController,
                focusNode: passwordFocus,
                validator: (value) =>
                    CheckValidate().validatePassword(passwordFocus, value!),
                keyboardType: TextInputType.name,
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
                onPressed: registerUser,
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

  const _SignButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ButtonLayout(
      bgColor: SIGN_TEXT_COLOR,
      textColor: WHITE_COLOR,
      onPressed: onPressed,
      buttonText: '회원가입',
    );
  }
}
