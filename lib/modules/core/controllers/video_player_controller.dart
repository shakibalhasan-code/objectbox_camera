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

  Future<void>? initializeVideoPlayerFuture;

  void initializePlayer(String path) {
    if (path.isEmpty) {
      debugPrint('Error: Video path is empty');
      return;
    }

    videoPath.value = path;
    debugPrint('Initializing VideoPlayerController with path: $path');

    _disposeController();

    try {
      _controller = vp.VideoPlayerController.file(File(path));
      initializeVideoPlayerFuture = _controller!
          .initialize()
          .then((_) {
            debugPrint('VideoPlayerController initialized successfully');
            if (_controller != null) {
              _controller!.addListener(_videoListener);
              isInitialized.value = true;
              isPlaying.value = false;
              update();
            }
          })
          .catchError((error) {
            debugPrint('Failed to initialize VideoPlayerController: $error');
            isInitialized.value = false;
            isPlaying.value = false;
            update();
          });
    } catch (e) {
      debugPrint('Error creating VideoPlayerController: $e');
      isInitialized.value = false;
      isPlaying.value = false;
      initializeVideoPlayerFuture = null;
      update();
    }
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
    initializeVideoPlayerFuture = null;
  }

  @override
  void onClose() {
    _disposeController();
    super.onClose();
  }
}
