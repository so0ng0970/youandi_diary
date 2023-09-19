// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/const/color.dart';

class ButtonDialogLayout extends StatelessWidget {
  VoidCallback onPressed;
  String text;
  ButtonDialogLayout({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: HOMESCREEN_COLOR,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: Colors.black,
          ),
        ),
        height: 200,
        width: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/image/icon/cloud_icon.png',
              scale: 2.5,
            ),
            Text(text),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(
                    '아니요',
                    style: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onPressed,
                  child: const Text(
                    '네',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
