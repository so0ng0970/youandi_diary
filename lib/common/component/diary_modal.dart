import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  final bool _isInitialized = false;
  List<String> diaryCoverImages = [
    'asset/image/diary/diary1.jpg',
    'asset/image/diary/diary2.jpg',
    'asset/image/diary/diary3.jpg',
    'asset/image/diary/diary4.jpg',
  ];

  String selectedImage = 'asset/image/diary/diary1.jpg'; // 기본 이미지 설정
  final List<UserModel> _selectedMembers = [];
  String myId = '';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final myInfo = ref.watch(firebase_auth_Provider).when(
        data: (user) {
          String userName = user?.displayName ?? '';
          String userEmail = user?.email ?? '이메일 없음';
          String userPhotoUrl = user?.photoURL ?? '';
          String userId = user!.uid;

          UserModel myInfo = UserModel(
            userName: userName,
            email: userEmail,
            photoUrl: userPhotoUrl,
            id: userId,
          );
          myId = user.uid;

          setState(() {
            _selectedMembers.add(myInfo);
          });
        },
        error: (Object error, StackTrace? stackTrace) {
          // 에러 처리
        },
        loading: () {
          // 로딩 처리
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final friendSearch = ref.watch(userProvider).searchUser;
    final selectedMembersProvider = StateProvider<List<UserModel>>((ref) => []);

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
        Align(
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //  사용자 프로필 이미지 표시

                  selectedFriends(setState),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                    ),
                    child: DottedBorder(
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
                  ),
                ],
              ),
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
              modalSetState(
                () {
                  ref.read(userProvider).searchUser =
                      ref.read(userProvider).users;
                  for (var user in ref.read(userProvider).users) {
                    user.isChecked = false;
                  }
                  _selectedMembers.removeWhere((e) => e.id != myId);
                },
              );
              setState(() {});
              context.pop(); // 다이얼로그 닫기
            },
            icon: Icons.arrow_back_ios_rounded,
            title: '친구 추가하기',
            buttonText: '친구 추가',
            mainOnPressed: () {
              setState(() {});
              print(_selectedMembers
                  .map(
                    (e) =>
                        'UserModel(id: ${e.id}, name: ${e.userName}, email: ${e.email},${e.id})',
                  )
                  .toList());

              context.pop();
            },
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
                                          modalSetState(
                                            () => selectFriend(
                                              value,
                                              friend,
                                            ),
                                          );
                                        });
                                  },
                                );
                        },
                      ),
                    ),
                    selectedFriends(modalSetState),
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }

  Widget selectedFriends(
    StateSetter modalSetState,
  ) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: _selectedMembers
              .map(
                (friend) => Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: selectImage(
                              friend.photoUrl,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            friend.userName.length > 7
                                ? '${friend.userName.substring(0, 7)}...'
                                : friend.userName,
                          ),
                          Text(
                            friend.email.length > 7
                                ? '${friend.email.substring(0, 7)}...'
                                : friend.email,
                          ),
                        ],
                      ),
                      if (friend.id != myId)
                        Positioned(
                          top: -14,
                          left: 24,
                          child: IconButton(
                            onPressed: () {
                              modalSetState(
                                  () => {selectFriend(false, friend)});
                              (() => {selectFriend(false, friend)});
                            },
                            icon: const Icon(
                              Icons.remove_circle_rounded,
                              color: REMOVE_COLOR,
                            ),
                          ),
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

  void selectFriend(bool? value, UserModel friend) {
    friend.isChecked = value ?? false;
    if (value ?? false) {
      _selectedMembers.add(friend);
    } else {
      _selectedMembers.removeWhere((user) => user.id == friend.id);
    }
  }

  ImageProvider selectImage(String? imageUrl) {
    if (imageUrl != null &&
        (imageUrl.startsWith('http') || imageUrl.startsWith('https'))) {
      return NetworkImage(imageUrl);
    } else {
      return AssetImage(
        imageUrl.toString(),
      );
    }
  }
}
