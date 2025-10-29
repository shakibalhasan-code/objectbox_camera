import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatelessWidget {
  final String videoPath;
  const CustomVideoPlayer({super.key, required this.videoPath});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      child: VideoPlayer(VideoPlayerController.file(File(videoPath))),
    );
  }
}
