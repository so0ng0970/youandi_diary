import 'package:flutter/material.dart';
import 'package:youandi_diary/const/color.dart';

class SignLoginLayout extends StatelessWidget {
  final Widget child;
  final String titleText;
  final AppBar? appBar;
  const SignLoginLayout({
    required this.titleText,
    required this.child,
    this.appBar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.blue[100],
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            SizedBox(
                height: appBar != null
                    ? MediaQuery.of(context).size.height / 3 - kToolbarHeight
                    : MediaQuery.of(context).size.height / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      titleText,
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: WHITE_COLOR,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(10, 5),
                              blurRadius: 15,
                            ),
                          ]),
                    ),
                  ],
                )),
            Container(
              height: MediaQuery.of(context).size.height * 2 / 3,
              decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(
                    90,
                  ),
                ),
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
