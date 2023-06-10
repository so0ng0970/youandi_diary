import 'package:flutter/material.dart';

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
            Container(
              margin: const EdgeInsets.fromLTRB(20, 50, 20, 0),
              child: Column(
                children: [
                  Text(
                    titleText,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                  margin: const EdgeInsets.only(top: 80),
                  height: MediaQuery.of(context).size.height - 280,
                  width: MediaQuery.of(context).size.width - 80,
                  decoration: BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: child),
            ),
          ],
        ),
      ),
    );
  }
}
