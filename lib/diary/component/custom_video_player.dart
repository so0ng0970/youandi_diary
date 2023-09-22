// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final XFile? video;
  final String? videoUrl;
  final VoidCallback? onNewVideoPressed;
  bool? edit = false;
  CustomVideoPlayer({
    Key? key,
    this.video,
    this.videoUrl,
    this.onNewVideoPressed,
    this.edit,
  }) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoController;
  Duration currentPosition = const Duration();
  bool showControls = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeController();
  }

// 새영상 실행할때 initializeController() 초기화
  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.video?.path != widget.video?.path) {
      initializeController();
    }
  }

  @override
  void dispose() {
    // Dispose the video player controller to free up resources.
    videoController?.removeListener(_videoPlayerListener);
    videoController?.dispose();

    super.dispose();
  }

  void _videoPlayerListener() {
    if (mounted) {
      final currentPosition = videoController!.value.position;
      setState(() {
        this.currentPosition = currentPosition;
      });
    }
  }

  initializeController() async {
    // 새로운 영상을 받았을때 초기화 시켜줘야한다.
    currentPosition = const Duration();

    if (widget.video != null) {
      videoController = VideoPlayerController.file(
        File(widget.video!.path),
      );
    } else if (widget.videoUrl != null) {
      videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl!),
      );
    }
    await videoController?.initialize();

    videoController?.addListener(() {
      final currentPosition = videoController!.value.position;
      setState(() {
        this.currentPosition = currentPosition;
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (videoController == null) {
      return const CircularProgressIndicator();
    }

    return Center(
      child: AspectRatio(
        aspectRatio: videoController!.value.aspectRatio,
        child: GestureDetector(
          onTap: () {
            setState(() {
              showControls = !showControls;
            });
          },
          child: Stack(
            children: [
              VideoPlayer(
                videoController!,
              ),
              if (showControls)
                _Controls(
                  onReversePressed: onReversePressed,
                  onPlayPressed: onPlayPressed,
                  isPlay: videoController!.value.isPlaying,
                  onForwardPressed: onForwardPressed,
                ),
              if (showControls && widget.edit == true)
                _NewVideo(
                  onPressed: widget.onNewVideoPressed!,
                ),
              _SliderBottom(
                onSliderChanged: onSliderChanged,
                currentPosition: currentPosition,
                maxPosition: videoController!.value.duration,
              )
            ],
          ),
        ),
      ),
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
      right: 45,
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
