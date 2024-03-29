import 'dart:core';

import 'package:flutter/material.dart';

import '../../common/const/color.dart';

TextFormField textFormField({
  required String hintText,
  TextEditingController? controller,
  FocusNode? focusNode,
  String? Function(String?)? validator,
  void Function(String)? onChanged,
  int? maxLength,
  bool? obscureText,
  required TextInputType keyboardType,
  required Key key,
}) {
  return TextFormField(
    key: key,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    controller: controller,
    onChanged: onChanged,
    focusNode: focusNode,
    validator: validator,
    maxLength: maxLength,
    keyboardType: keyboardType,
    obscureText: obscureText ?? false,
    decoration: InputDecoration(
      hintText: hintText,
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: UNDERLINE_INPUT_COLOR,
        ),
      ),
    ),
  );
}

class CheckValidate {
  String? validatelength({
    required FocusNode focusNode,
    required String value,
    required String title,
  }) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '$title를 입력하세요.';
    } else {
      return null;
    }
  }

  String? validateNickName(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '닉네임을 입력하세요(1-9이하).';
    } else {
      RegExp pattern = RegExp(r'^[\wㄱ-ㅎㅏ-ㅣ가-힣]{1,9}$');
      if (!pattern.hasMatch(value)) {
        focusNode.requestFocus();
        return '닉네임은 1자에서 9자까지 허용됩니다.';
      } else {
        return null;
      }
    }
  }

  String? validateEmail(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '이메일을 입력하세요.';
    } else {
      RegExp pattern = RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
      if (!pattern.hasMatch(value)) {
        focusNode.requestFocus();
        return '잘못된 이메일 형식입니다.';
      } else {
        return null;
      }
    }
  }

  String? validatePassword(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '비밀번호를 입력하세요.';
    } else {
      RegExp pattern = RegExp(
          r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,15}$');

      if (!pattern.hasMatch(value)) {
        focusNode.requestFocus();
        return '특수문자,숫자,문자 포함 8자 이상 15자 이내로 입력하세요.';
      } else {
        return null;
      }
    }
  }

  String? validatePasswordConfirmation(
      FocusNode focusNode, String value, String password) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '비밀번호 (확인)을 입력하세요.';
    } else if (value != password) {
      focusNode.requestFocus();
      return '비밀번호가 일치하지 않습니다.';
    } else {
      return null;
    }
  }
}
