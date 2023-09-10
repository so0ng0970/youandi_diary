import 'package:flutter/material.dart';
import 'package:youandi_diary/user/layout/default_layout.dart';

import '../../common/const/color.dart';

class DiaryPostScreen extends StatelessWidget {
  static String get routeName => 'post';
  const DiaryPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      color: DIARY_DETAIL_COLOR,
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  print('d');
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 3.5,
                  width: MediaQuery.of(context).size.width - 70,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: WHITE_COLOR,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(
                      50,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'asset/image/icon/photo.png',
                        scale: 4,
                      ),
                      const Text(
                        'add photo & video +',
                        style: TextStyle(
                          color: WHITE_COLOR,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                color: ADD_BG_COLOR,
                height: MediaQuery.of(context).size.height / 2.2,
                width: MediaQuery.of(context).size.width - 70,
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: '제목',
                          // border: OutlineInputBorder(
                          //   borderSide: BorderSide(color: Colors.grey, width: 2.0),
                          // ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: TEXT_OUTLINE_COLOR,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: '내용',
                          border: InputBorder.none,
                          focusedBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text(
                  '글작성',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
