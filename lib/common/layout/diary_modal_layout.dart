import 'package:flutter/material.dart';
import 'package:youandi_diary/common/const/color.dart';

class DiaryModalLayout extends StatelessWidget {
  final String title;
  final String buttonText;
  final IconData icon;
  final VoidCallback? onPressed;
  final VoidCallback? mainOnPressed;
  final List<Widget> children;

  const DiaryModalLayout({
    required this.icon,
    required this.children,
    required this.title,
    this.onPressed,
    super.key,
    required this.buttonText,
    this.mainOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
          color: MODAL_COLOR,
        ),
        width: 350,
        height: 500,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(
              10.0,
            ),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: onPressed,
                        child: Icon(
                          icon,
                          color: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: children,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MODAL_BUTTON,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                      ),
                    ),
                    onPressed: mainOnPressed,
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
