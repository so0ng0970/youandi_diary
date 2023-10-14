import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletons/skeletons.dart';
import 'package:youandi_diary/user/model/user_model.dart';
import 'package:youandi_diary/user/provider/profile_user_provider.dart';

import '../../common/const/color.dart';

class UserProfile extends ConsumerStatefulWidget {
  static String get routeName => '/profile';
  const UserProfile({Key? key}) : super(key: key);

  @override
  ConsumerState<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {
  bool edit = false;
  bool imageEdit = false;
  bool basicImage = false;
  bool isLoading = false;
  XFile? selectImage;
  TextEditingController userNameController = TextEditingController();
  final firebaseStorage = FirebaseStorage.instance;
  int index = 0;
  Positioned positioned(
      {required VoidCallback onPressed, required IconData icons}) {
    return Positioned(
      right: 10,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icons,
          size: 50,
          color: Colors.grey,
        ),
      ),
    );
  }

  ClipOval clipOval({required String imgUrl}) {
    final image = NetworkImage(imgUrl);
    return ClipOval(
      child: Image(
        image: image,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return const Center(
            child: SkeletonAvatar(
              style: SkeletonAvatarStyle(
                shape: BoxShape.circle,
                width: 200,
                height: 200,
              ),
            ),
          );
        },
      ),
    );
  }

  OutlineInputBorder inputDecoration = OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      20,
    ),
    borderSide: const BorderSide(
      color: Colors.black,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return ref.watch(userGetProvider).when(
          data: (data) {
            return SafeArea(
              child: Center(
                child: Column(
                  children: [
                    Row(
                      children: [
                        if (edit)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                basicImage = false;
                                imageEdit = false;
                                selectImage = null;
                                edit = false;
                              });
                            },
                            child: const Text(
                              '취소',
                              style: TextStyle(
                                color: REMOVE_COLOR,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        const Spacer(),
                        TextButton(
                          onPressed: () async {
                            if (edit) {
                              await performUpdate(data);
                            } else {
                              setState(() {
                                edit = true;
                                imageEdit = true;
                                userNameController.text = data!.userName;
                              });
                            }
                          },
                          child: edit
                              ? const Text(
                                  '수정완료',
                                  style: TextStyle(
                                    color: DIARY_DETAIL_COLOR,
                                    fontSize: 20,
                                  ),
                                )
                              : const Icon(
                                  Icons.settings,
                                  color: EDITBUTTON,
                                  size: 30,
                                ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        clipOval(imgUrl: data!.photoUrl),
                        if (edit && !basicImage)
                          GestureDetector(
                            onTap: () {
                              mediaDialog(context);
                            },
                            child: selectImage != null
                                ? ClipOval(
                                    child: Image.file(
                                      File(
                                        selectImage!.path,
                                      ),
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : clipOval(
                                    imgUrl: data.photoUrl,
                                  ),
                          ),
                        if (basicImage)
                          GestureDetector(
                            onTap: () {
                              mediaDialog(context);
                            },
                            child: ClipOval(
                              child: Image.asset(
                                'assets/image/diary/profile.jpg',
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        if (imageEdit)
                          const Positioned(
                            bottom: 10,
                            right: 20,
                            child: Icon(
                              Icons.photo_camera_back_rounded,
                              color: CAMERABUTTON,
                              size: 35,
                            ),
                          )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    if (!edit)
                      Text(
                        data.userName,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    if (edit)
                      TextFormField(
                        controller: userNameController,
                        decoration: InputDecoration(
                          filled: true,
                          focusedBorder: inputDecoration,
                          enabledBorder: inputDecoration,
                          contentPadding: const EdgeInsets.all(5.0),
                        ),
                      ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      data.email.toString(),
                    )
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: Colors.amber,
            ),
          ),
          error: (error, stackTrace) => const Text(
            '데이터를 불러오지 못했습니다',
          ),
        );
  }

  final picker = ImagePicker();
  void getImage() async {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      selectImage = XFile(pickedFile!.path);
    });
  }

  Future<void> performUpdate(UserModel? data) async {
    setState(() {
      isLoading = true;
    });
    if (selectImage != null) {
      final ref =
          firebaseStorage.ref().child('user').child(data!.uid.toString());
      await ref.putFile(File(selectImage!.path));
      data.photoUrl = await ref.getDownloadURL();
    } else if (selectImage == null && basicImage) {
      final ref = firebaseStorage.ref().child('user/profile.jpg');
      data!.photoUrl = await ref.getDownloadURL();
    }

    final Map<String, dynamic> userData = {
      'uid': data!.uid,
      'userName': userNameController.text,
      'photoUrl': data.photoUrl,
    };

    ref.watch(userUpdateProvider(userData));

    setState(() {
      edit = false;
      if (edit) {
        userNameController.text = data.userName;
      }
      imageEdit = false;
      isLoading = false;
    });
  }

  Future<dynamic> mediaDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final content = Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Divider(
                    height: 1,
                  ),
                  TextButton(
                    onPressed: () {
                      getImage();
                      basicImage = false;
                      context.pop();
                    },
                    child: const Text("앨범에서 사진 선택"),
                  ),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        selectImage = null;
                        basicImage = true;
                        context.pop();
                      });
                    },
                    child: const Text("기본 이미지로 변경"),
                  ),
                  const Divider(
                    height: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    10.0,
                  ),
                ),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "취소",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        );
        return FractionallySizedBox(
          widthFactor: 0.9,
          child: Material(
            type: MaterialType.transparency,
            child: content,
          ),
        );
      },
    );
  }
}
