import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late bool isError = false;
  List<String> diaryCoverImages = [
    'assets/image/diary/diary1.jpg',
    'assets/image/diary/diary2.jpg',
    'assets/image/diary/diary3.jpg',
    'assets/image/diary/diary4.jpg',
  ];

  String selectedImage = 'assets/image/diary/diary1.jpg'; // 기본 이미지 설정

  String myId = '';
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? get currentUserId => auth.currentUser?.uid;

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
    String? errorMessage;
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
        if (formKey.currentState?.validate() ?? false) {
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
          // await ref.read(diaryListProvider).addDiary(savedDiary);

          context.pop();
          selectMemberProvider.reset();
          ref.read(userProvider).resetSearch();
        }
      },
      children: [
        Form(
          key: formKey,
          child: TextFormField(
            key: const ValueKey(1),
            controller: titleFocusController,
            focusNode: titleFocus,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                isError = true;
                errorMessage = '제목을 입력해주세요';
                return errorMessage;
              }
              isError = false;
              return null;
            },
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              filled: true,
              fillColor: WHITE_COLOR,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(32.0),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    50,
                  ),
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    50,
                  ),
                ),
              ),
              hintText: '제목 ',
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
                    onTap: () async {
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
              () {
                ref.watch(userProvider).searchUser =
                    ref.watch(userProvider).users;
                for (var user in ref.watch(userProvider).users) {
                  user.isChecked = false;
                }
                selectMember.state.removeWhere((e) => e.uid != currentUserId);
              };

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
                            ref.read(userProvider).clearSearch();
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ),
                    ),
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
                      if (friend.uid != currentUserId)
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
      selectMember.add(friend);
    } else {
      selectMember.remove(friend);
    }
  }
}
