import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youandi_diary/common/const/color.dart';
import 'package:youandi_diary/common/layout/diary_modal_layout.dart';
import 'package:youandi_diary/user/model/user_model.dart';
import 'package:youandi_diary/user/provider/select_member_provider.dart';
import '../../diary/model/diary_model.dart';
import '../../diary/provider/diary_provider.dart';
import '../../user/provider/user_provider.dart';

class DiaryModal extends ConsumerStatefulWidget {
  static String get routeName => 'diaryModal';

  const DiaryModal({Key? key}) : super(key: key);

  @override
  ConsumerState<DiaryModal> createState() => _DiaryModalState();
}

class _DiaryModalState extends ConsumerState<DiaryModal> {
  final FocusNode titleFocus = FocusNode();
  final TextEditingController titleFocusController = TextEditingController();
  final bool _isInitialized = false;
  List<String> diaryCoverImages = [
    'asset/image/diary/diary1.jpg',
    'asset/image/diary/diary2.jpg',
    'asset/image/diary/diary3.jpg',
    'asset/image/diary/diary4.jpg',
  ];

  String selectedImage = 'asset/image/diary/diary1.jpg'; // 기본 이미지 설정

  String myId = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // if (!_isInitialized) {
    //   ref.watch(firebase_auth_Provider).when(
    //     data: (user) {
    //       String userName = user?.displayName ?? '';
    //       String userEmail = user?.email ?? '이메일 없음';
    //       String userPhotoUrl = user?.photoURL ?? '';
    //       String userId = user!.uid;

    //       UserModel myInfo = UserModel(
    //         userName: userName,
    //         email: userEmail,
    //         photoUrl: userPhotoUrl,
    //         uid: userId,
    //       );
    //       myId = user.uid;
    //       final selectMemberNotifier =
    //           ref.read(selectedMembersProvider.notifier);

    //       Future.microtask(() => selectMemberNotifier.add(myInfo));
    //     },
    //     error: (Object error, StackTrace? stackTrace) {
    //       // 에러 처리
    //     },
    //     loading: () {
    //       // 로딩 처리
    //       Column(
    //         children: const [
    //           SkeletonAvatar(),
    //         ],
    //       );
    //     },
    //   );
    //   _isInitialized = true;
    // }
  }

  @override
  void dispose() {
    titleFocus.dispose();
    titleFocusController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectMemberProvider = ref.watch(selectedMembersProvider.notifier);
    final dateTime = DateTime.now();

    return DiaryModalLayout(
      onPressed: () {
        Navigator.of(context).pop();
        selectMemberProvider.reset();
        ref.read(userProvider).resetSearch();
      },
      icon: Icons.close,
      title: '다이어리 만들기 ',
      buttonText: '제작하기',
      mainOnPressed: () async {
        DiaryModel savedDiary =
            await ref.watch(diaryProvider).saveDiaryToFirestore(
                  DiaryModel(
                    dataTime: dateTime,
                    title: titleFocusController.text,
                    coverImg: selectedImage,
                    member: selectMemberProvider.state
                        .map((UserModel user) => UserModel(
                              uid: user.uid,
                              userName: user.userName,
                              photoUrl: user.photoUrl,
                            ))
                        .toList(),
                  ),
                );
        await ref.read(diaryListProvider).addDiary(savedDiary);

        context.pop();
        selectMemberProvider.reset();
        ref.read(userProvider).resetSearch();
      },
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
            key: const ValueKey(1),
            controller: titleFocusController,
            focusNode: titleFocus,
            keyboardType: TextInputType.name,
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
        SizedBox(
          height: 130,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
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
                      margin: const EdgeInsets.all(6.0),
                      width: selectedImage == imagePath ? 110 : 100,
                      height: selectedImage == imagePath ? 130 : 100,
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
          height: 10,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  selectedFriends(setState, selectMemberProvider),
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
                          memberModal(context, selectMemberProvider);
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

  void memberModal(BuildContext context, SelectedMembers selectMember) {
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
                  selectMember.state.removeWhere((e) => e.uid != myId);
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
                              ref.watch(userProvider.notifier).searchUser;
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
                                          friend.email!,
                                        ),
                                        value: friend.isChecked,
                                        onChanged: (bool? value) {
                                          modalSetState(
                                            () => selectFriend(
                                                value, friend, selectMember),
                                          );
                                        });
                                  },
                                );
                        },
                      ),
                    ),
                    selectedFriends(modalSetState, selectMember),
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
      StateSetter modalSetState, SelectedMembers selectMember) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: selectMember.state
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
                              imageUrl: friend.photoUrl,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            friend.userName.length > 7
                                ? '${friend.userName.substring(0, 7)}...'
                                : friend.userName,
                          ),
                          Text(
                            friend.email!.length > 7
                                ? '${friend.email!.substring(0, 7)}...'
                                : friend.email!,
                          ),
                        ],
                      ),
                      if (friend.uid != myId)
                        Positioned(
                          top: -14,
                          left: 24,
                          child: IconButton(
                            onPressed: () {
                              modalSetState(() =>
                                  {selectFriend(false, friend, selectMember)});
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

  void selectFriend(bool? value, UserModel friend, selectMember) {
    friend.isChecked = value ?? false;
    if (value ?? false) {
      selectMember.add(friend); // add method from SelectedMembers class
    } else {
      selectMember.remove(friend); // remove method from SelectedMembers class
    }
  }
}
