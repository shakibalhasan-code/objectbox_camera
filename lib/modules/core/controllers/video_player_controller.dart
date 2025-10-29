import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart' as vp;

class CustomVideoPlayerController extends GetxController {
  vp.VideoPlayerController? _controller;
  vp.VideoPlayerController? get controller => _controller;

  final isInitialized = false.obs;
  final isPlaying = false.obs;
  final videoPath = ''.obs;

  late Future<void> initializeVideoPlayerFuture;

  void initializePlayer(String path) {
    videoPath.value = path;
    debugPrint('Initializing VideoPlayerController with path: $path');

    _disposeController();

    _controller = vp.VideoPlayerController.file(File(path));
    initializeVideoPlayerFuture = _controller!
        .initialize()
        .then((_) {
          debugPrint('VideoPlayerController initialized successfully');
          _controller!.addListener(_videoListener);
          isInitialized.value = true;
          isPlaying.value = false;
          update();
        })
        .catchError((error) {
          debugPrint('Failed to initialize VideoPlayerController: $error');
        });
  }

  void _videoListener() {
    if (_controller != null &&
        _controller!.value.isPlaying != isPlaying.value) {
      isPlaying.value = _controller!.value.isPlaying;
    }
  }

  void togglePlayPause() {
    if (_controller == null || !isInitialized.value) return;

    if (_controller!.value.isPlaying) {
      _controller!.pause();
      isPlaying.value = false;
    } else {
      _controller!.play();
      isPlaying.value = true;
    }
    update();
  }

  void _disposeController() {
    if (_controller != null) {
      _controller!.removeListener(_videoListener);
      _controller!.dispose();
      _controller = null;
    }
    isInitialized.value = false;
    isPlaying.value = false;
  }

  @override
  void onClose() {
    _disposeController();
    super.onClose();
  }
}
