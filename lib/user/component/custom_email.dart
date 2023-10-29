import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/const/color.dart';

CustomDropdown customDropdown = CustomDropdown();

class CustomDropdown {
  OverlayEntry emailRecommendation({
    required double width,
    required LayerLink layerLink,
    required TextEditingController controller,
    required Function onPressed,
  }) {
    const List<String> emailList = [
      '@gmail.com',
      '@hotmail.com',
      '@naver.com',
      '@kakao.com',
      '@daum.net',
    ];
    final emailListLength = emailList.length;

    return OverlayEntry(
      maintainState: true,
      builder: (context) => Positioned(
        width: width,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 48),
          child: Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: const BorderSide(color: UNDERLINE_INPUT_COLOR),
            ),
            color: Colors.white,
            child: Container(
              height:
                  (22.0 * emailListLength) + (21 * (emailListLength - 1)) + 20,
              decoration: BoxDecoration(
                border: Border.all(color: UNDERLINE_INPUT_COLOR),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListView.separated(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: emailList.length,
                itemBuilder: (context, index) {
                  return CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    pressedOpacity: 1,
                    minSize: 0,
                    onPressed: () {
                      controller.text += emailList.elementAt(index);

                      onPressed();
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${controller.text}${emailList.elementAt(index)}',
                        style: const TextStyle(
                          fontSize: 16,
                          height: 22 / 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Divider(
                      color: Colors.grey,
                      height: 20,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
