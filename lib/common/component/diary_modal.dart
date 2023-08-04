import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youandi_diary/common/const/color.dart';
import 'package:youandi_diary/common/layout/diary_modal_layout.dart';
import 'package:youandi_diary/user/model/user_model.dart';

import '../../user/provider/firebase_auth_provider.dart';
import '../../user/provider/user_provider.dart';

class DiaryModal extends ConsumerStatefulWidget {
  static String get routeName => 'diaryModal';
  const DiaryModal({Key? key}) : super(key: key);

  @override
  ConsumerState<DiaryModal> createState() => _DiaryModalState();
}

class _DiaryModalState extends ConsumerState<DiaryModal> {
  List<String> diaryCoverImages = [
    'asset/image/diary/diary1.jpg',
    'asset/image/diary/diary2.jpg',
    'asset/image/diary/diary3.jpg',
    'asset/image/diary/diary4.jpg',
  ];
  String selectedImage = 'asset/image/diary/diary1.jpg'; // 기본 이미지 설정
  final List<UserModel> _selectedMembers = [];
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(firebase_auth_Provider);
    final friendSearch = ref.watch(userProvider).searchUser;

    return DiaryModalLayout(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: Icons.close,
      title: '다이어리 만들기 ',
      buttonText: '제작하기',
      mainOnPressed: () {},
      children: [
        Container(
          decoration: const ShapeDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFe6dfd8),
                Color(
                  0xFFf7f5ec,
                ),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.4],
              tileMode: TileMode.clamp,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  50.0,
                ),
              ),
            ),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(32.0),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    50,
                  ),
                ),
              ),
              hintText: '제목',
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        const Text(
          '다이어리 커버 고르기',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            color: WHITE_COLOR,
            width: 430,
            height: 115,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100.0,
                  crossAxisSpacing: 8.0,
                ),
                itemCount: diaryCoverImages.length,
                itemBuilder: (context, index) {
                  final imagePath = diaryCoverImages[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedImage = imagePath;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ),
                        image: DecorationImage(
                          image: AssetImage(imagePath),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: selectedImage == imagePath
                              ? Colors.blue
                              : Colors.transparent,
                          width: 3.0,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //  사용자 프로필 이미지 표시
                authState.when(
                  data: (user) {
                    if (user != null) {
                      return CircleAvatar(
                        backgroundColor: Colors.blue[900],
                        radius: 32,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            user.photoURL ?? '',
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox(); // 유저 데이터가 없을 경우 빈 SizedBox를 반환하거나 다른 대체 위젯을 사용할 수 있습니다.
                    }
                  },
                  loading: () =>
                      const CircularProgressIndicator(), // 로딩 중일 때 표시할 위젯
                  error: (error, stackTrace) =>
                      Text('Error: $error'), // 에러 발생 시 표시할 위젯
                ),

                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: DottedBorder(
                    padding: const EdgeInsets.all(7),
                    borderType: BorderType.Circle,
                    color: Colors.grey[700]!,
                    strokeWidth: 1,
                    child: IconButton(
                      onPressed: () {
                        memberModal(
                          context,
                        );
                      },
                      icon: Icon(
                        Icons.add,
                        size: 30.0,
                        color: Colors.grey[900]!,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void memberModal(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter modalSetState) {
          return DiaryModalLayout(
            onPressed: () {
              modalSetState(() {
                ref.read(userProvider).searchUser =
                    ref.read(userProvider).users;
              });
              // 검색 기록 초기화
              Navigator.of(context).pop(); // 다이얼로그 닫기
            },
            icon: Icons.arrow_back_ios_rounded,
            title: '친구 추가하기',
            buttonText: '친구 추가',
            mainOnPressed: () {},
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // 열이 자식에 맞게 크기를 조정
                  children: [
                    TextField(
                      controller: searchController,
                      onChanged: (value) {
                        ref.read(userProvider).search(value);
                        modalSetState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: "초대 보낼 이메일을 입력해주세요",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          onPressed: () {
                            searchController.clear();
                            ref
                                .read(userProvider)
                                .clearSearch(); // searchUser 목록 초기화
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ),
                    ),
                    // 검색된 친구 목록 (searchUser)을 표시하는 위젯 추가
                    SizedBox(
                      height: 200,
                      child: Consumer(
                        builder: (context, watch, child) {
                          final friendSearch =
                              ref.read(userProvider).searchUser;
                          final textIsEmpty = searchController.text.isEmpty;
                          return textIsEmpty
                              ? Container()
                              : ListView.builder(
                                  shrinkWrap:
                                      true, // ListView가 스크롤 가능한 상위 위젯에 맞게 크기를 조정 .
                                  itemCount: friendSearch.length,
                                  itemBuilder: (context, index) {
                                    final friend = friendSearch[index];

                                    return CheckboxListTile(
                                        title: Text(
                                          friend.userName,
                                        ),
                                        subtitle: Text(
                                          friend.email,
                                        ),
                                        value: friend.isChecked,
                                        onChanged: (bool? value) {
                                          modalSetState(() {
                                            if (value != null) {
                                              modalSetState(() {
                                                friend.isChecked = value;
                                                if (value) {
                                                  _selectedMembers.add(friend);
                                                } else {
                                                  _selectedMembers.removeWhere(
                                                      (user) =>
                                                          user.id == friend.id);
                                                }
                                              });
                                            }
                                          });
                                        });
                                  },
                                );
                        },
                      ),
                    ),
                    selectedFriends(),
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }

  Widget selectedFriends() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: _selectedMembers
              .map(
                (friend) => Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: selectImage(friend.photoUrl),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        friend.userName.length > 7
                            ? '${friend.userName.substring(0, 7)}...'
                            : friend.userName,
                      ),
                      // 여기서 이메일을 자르는 논리를 추가합니다.
                      Text(
                        friend.email.length > 7
                            ? '${friend.email.substring(0, 7)}...'
                            : friend.email,
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  ImageProvider selectImage(String? imageUrl) {
    if (imageUrl != null &&
        (imageUrl.startsWith('http') || imageUrl.startsWith('https'))) {
      return NetworkImage(imageUrl);
    } else {
      return const AssetImage('asset/image/diary/diary1.jpg');
    }
  }
}
