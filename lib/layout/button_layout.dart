import 'package:flutter/material.dart';

class ButtonLayout extends StatelessWidget {
  final VoidCallback onPressed;
  final Color bgColor;
  final Color textColor;
  final String imageIcon;
  final String buttonText;

  const ButtonLayout(
      {required this.bgColor,
      required this.textColor,
      required this.onPressed,
      super.key,
      required this.imageIcon,
      required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 2.0,
        backgroundColor: bgColor,
        minimumSize: const Size(50, 50),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 30,
              child: Image.asset(
                imageIcon,
              ),
            ),
            Text(
              buttonText,
              style: TextStyle(
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
