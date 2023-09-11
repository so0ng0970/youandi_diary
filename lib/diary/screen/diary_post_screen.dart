import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:youandi_diary/user/layout/default_layout.dart';

import '../../common/const/color.dart';
import '../../user/provider/video_provider.dart';

class DiaryPostScreen extends ConsumerStatefulWidget {
  static String get routeName => 'post';
  const DiaryPostScreen({super.key});

  @override
  ConsumerState<DiaryPostScreen> createState() => _DiaryPostScreenState();
}

class _DiaryPostScreenState extends ConsumerState<DiaryPostScreen> {
  List<File> selectedImages = [];
  late List<File> selectedVideo = [];
  VideoPlayerController? videoController;
  Duration currentPosition = const Duration();
  bool showControls = false;

  @override
  Widget build(
    BuildContext context,
  ) {
    return DefaultLayout(
      color: DIARY_DETAIL_COLOR,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    mediaDialog(context);
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        50,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (selectedImages.isEmpty && selectedVideo.isEmpty)
                            Image.asset(
                              'asset/image/icon/photo.png',
                              scale: 4,
                            ),
                          if (selectedImages.isEmpty && selectedVideo.isEmpty)
                            const Text(
                              'add photo & video +',
                              style: TextStyle(
                                color: WHITE_COLOR,
                                fontSize: 20,
                              ),
                            ),
                          if (selectedImages.isNotEmpty)
                            Expanded(
                              child: PageView.builder(
                                itemCount: selectedImages.length,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      Center(
                                        child: Image.file(
                                          selectedImages[index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        right: 10.0,
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              selectedImages.removeAt(index);
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.remove_circle_outlined,
                                            size: 30,
                                            color: WHITE_COLOR,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          if (selectedVideo.isNotEmpty)
                            Stack(
                              children: [
                                AspectRatio(
                                  aspectRatio:
                                      videoController!.value.aspectRatio,
                                  child: VideoPlayer(
                                    videoController!,
                                  ),
                                ),
                                if (showControls)
                                  _Controls(
                                    onReversePressed: onReversePressed,
                                    onPlayPressed: onPlayPressed,
                                    isPlay: videoController!.value.isPlaying,
                                    onForwardPressed: onForwardPressed,
                                  ),
                                _SliderBottom(
                                  onSliderChanged: onSliderChanged,
                                  currentPosition: currentPosition,
                                  maxPosition: videoController!.value.duration,
                                ),
                                Positioned(
                                  right: 10.0,
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedVideo.clear();
                                        videoController!.dispose();
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle_outlined,
                                      size: 30,
                                      color: WHITE_COLOR,
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                            autocorrect: true,
                            maxLines: null,
                            decoration: const InputDecoration(
                              hintText: '내용',
                              border: InputBorder.none,
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ],
                      ),
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
      ),
    );
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
                  TextButton(
                    onPressed: () {
                      _getCamera();
                    },
                    child: const Text("카메라"),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  TextButton(
                    onPressed: () {
                      getImages();
                    },
                    child: const Text("사진"),
                  ),
                  TextButton(
                    onPressed: () {
                      pickVideo(ImageSource.gallery);
                    },
                    child: const Text("동영상"),
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

  void onSliderChanged(double val) {
    videoController!.seekTo(
      Duration(seconds: val.toInt()),
    );
  }

  void onReversePressed() {
    final currentPosition = videoController!.value.position;

    Duration position = const Duration(); // 0초

    if (currentPosition.inSeconds > 2) {
      position = currentPosition - const Duration(seconds: 2);
    }

    videoController!.seekTo(position);
  }

  void onPlayPressed() {
    // 이미 실행중이면 중지
    // 실행중이면 중지

    setState(() {
      if (videoController!.value.isPlaying) {
        videoController!.pause();
      } else {
        videoController!.play();
      }
    });
  }

  void onForwardPressed() {
    // 전체 총길이
    final maxPosition = videoController!.value.duration;
    final currentPosition = videoController!.value.position;
    Duration position = maxPosition;
    if ((maxPosition - const Duration(seconds: 2)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + const Duration(seconds: 2);
    }

    videoController!.seekTo(position);
  }

  XFile? _pickedFile;
  _getCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  final picker = ImagePicker();
  Future getImages() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;

    if (xfilePick.isNotEmpty) {
      for (var i = 0; i < xfilePick.length; i++) {
        selectedImages.add(File(xfilePick[i].path));
      }
      selectedVideo.clear();
      setState(
        () {
          context.pop();
        },
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Nothing is selected')));
    }
  }

  Future pickVideo(ImageSource source) async {
    final XFile? file = await ImagePicker()
        .pickVideo(source: source, maxDuration: const Duration(seconds: 10));
    if (file != null) {
      ref.watch(selectedVideoProvider.notifier).insertVideo(file);
      videoController = VideoPlayerController.network(file.path)
        ..initialize().then((_) {
          videoController!.addListener(() {
            setState(() {
              ref
                  .watch(videoStateProvider.notifier)
                  .update((state) => videoController!.value.isPlaying);
            });
          });
          selectedVideo.add(File(file.path));
          selectedImages.clear();
          context.pop();
          setState(() {});
        });
    }
  }
}

class _SliderBottom extends StatelessWidget {
  const _SliderBottom({
    Key? key,
    required this.currentPosition,
    required this.maxPosition,
    required this.onSliderChanged,
  }) : super(key: key);

  final Duration currentPosition;
  final Duration maxPosition;
  final ValueChanged<double> onSliderChanged;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Text(
              '${currentPosition.inMinutes}:${(currentPosition.inSeconds % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Slider(
                  max: maxPosition.inSeconds.toDouble(),
                  min: 0,
                  value: currentPosition.inSeconds.toDouble(),
                  onChanged: onSliderChanged),
            ),
            Text(
              '${maxPosition.inMinutes}:${(maxPosition.inSeconds % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewVideo extends StatelessWidget {
  final VoidCallback onPressed;
  const _NewVideo({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // stack 쓸때 많이 씀 위치지정
    return Positioned(
      right: 1,
      child: IconButton(
        onPressed: onPressed,
        color: Colors.white,
        iconSize: 30.0,
        icon: const Icon(Icons.photo_camera_back),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  final VoidCallback onPlayPressed;
  final VoidCallback onReversePressed;
  final VoidCallback onForwardPressed;
  final bool isPlay;

  const _Controls({
    required this.onPlayPressed,
    required this.onReversePressed,
    required this.onForwardPressed,
    required this.isPlay,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          renderIconButton(
            onPressed: onReversePressed,
            iconData: Icons.rotate_left,
          ),
          renderIconButton(
            onPressed: onPlayPressed,
            iconData: isPlay ? Icons.pause : Icons.play_arrow,
          ),
          renderIconButton(
            onPressed: onForwardPressed,
            iconData: Icons.rotate_right,
          )
        ],
      ),
    );
  }

  Widget renderIconButton({
    required VoidCallback onPressed,
    required IconData iconData,
  }) {
    return IconButton(
      onPressed: onPressed,
      iconSize: 30.0,
      color: Colors.white,
      icon: Icon(iconData),
    );
  }
}
