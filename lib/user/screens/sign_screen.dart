import 'package:flutter/material.dart';
import 'package:youandi_diary/common/const/color.dart';
import 'package:youandi_diary/user/component/custom_email.dart';
import 'package:youandi_diary/user/layout/button_layout.dart';
import 'package:youandi_diary/user/layout/sign_login_layout.dart';
import 'package:youandi_diary/user/model/social_view_model.dart';
import 'package:youandi_diary/user/model/validate.dart';

class SignScreen extends StatefulWidget {
  static String get routeName => '/sign';
  const SignScreen({super.key});

  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  final FocusNode nicknameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();
  final TextEditingController nicknameFocusController = TextEditingController();
  final TextEditingController emailFocusController = TextEditingController();
  final TextEditingController passwordFocusController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void _removeEmailOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    nicknameFocusController.dispose();
    emailFocusController.dispose();
    passwordFocusController.dispose();
    _removeEmailOverlay();
    _overlayEntry?.dispose();
    emailFocus.dispose();
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
      titleText: 'Sign',
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
              textFormField(
                key: const ValueKey(1),
                maxLength: 15,
                controller: nicknameFocusController,
                focusNode: nicknameFocus,
                validator: (value) =>
                    CheckValidate().validateNickName(nicknameFocus, value!),
                keyboardType: TextInputType.name,
                hintText: '닉네임',
              ),
              CompositedTransformTarget(
                link: _layerLink,
                child: textFormField(
                  key: const ValueKey(2),
                  controller: emailFocusController,
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
                key: const ValueKey(3),
                controller: passwordFocusController,
                focusNode: passwordFocus,
                validator: (value) =>
                    CheckValidate().validatePassword(passwordFocus, value!),
                keyboardType: TextInputType.name,
                obscureText: true,
                hintText: '비밀번호',
              ),
              const SizedBox(
                height: 10,
              ),
              textFormField(
                key: const ValueKey(4),
                keyboardType: TextInputType.name,
                obscureText: true,
                validator: (val) => CheckValidate()
                    .validatePasswordConfirmation(confirmPasswordFocus, val!,
                        passwordFocusController.text),
                hintText: '비밀번호(확인)',
              ),
              const SizedBox(
                height: 50,
              ),
              _SignButton(
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    final viewModel = LoginSignModel(null);
                    await viewModel.registerUser(
                      context,
                      mounted,
                      nicknameFocusController,
                      emailFocusController,
                      passwordFocusController,
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showEmailOverlay() {
    if (emailFocus.hasFocus) {
      if (emailFocusController.text.isNotEmpty) {
        final email = emailFocusController.text;

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

  void _updateEmailOverlay() {
    _overlayEntry?.markNeedsBuild(); 
  }

  // 이메일 자동 입력창
  OverlayEntry _emailListOverlayEntry() {
    return customDropdown.emailRecommendation(
      width: MediaQuery.of(context).size.width - 100,
      layerLink: _layerLink,
      controller: emailFocusController,
      onPressed: () {
        setState(() {
          emailFocus.unfocus();
          _removeEmailOverlay();
        });
      },
    );
  }
}

class _SignButton extends StatelessWidget {
  final Future<void> Function() onPressed;

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
