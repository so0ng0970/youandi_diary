import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youandi_diary/user/layout/default_layout.dart';

import '../../common/const/color.dart';

class UserProfileScreen extends StatelessWidget {
  static String get routeName => '/profile';
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      popOnPressed: () {
        context.pop();
      },
      color: PRFBG,
      child: Column(),
    );
  }
}
