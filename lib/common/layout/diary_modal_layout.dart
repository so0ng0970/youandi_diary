import 'package:flutter/material.dart';

class DiaryModalLayout extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onPressed;
  final List<Widget> children;

  const DiaryModalLayout({
    required this.icon,
    required this.children,
    required this.title,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'asset/image/diary/modal_bg.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        width: 350,
        height: 500,
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
                const SizedBox(
                  height: 30,
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  children: children,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
