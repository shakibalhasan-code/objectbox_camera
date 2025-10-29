import 'dart:io';

import 'package:camera/camera.dart';
import 'package:crud_objtbx/modules/core/controllers/home_controller.dart';
import 'package:crud_objtbx/modules/core/models/video_entity.dart';
import 'package:crud_objtbx/modules/core/repo/video_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  CameraController? get cameraController => _cameraController;

  ///initialize our repo
  final videoRepo = Get.find<VideoRepo>();

  // Private instance
  CameraController? _cameraController;

  late Future<void> initializeControllerFuture;
  VideoPlayerController? videoPlayerController;

  final isRecording = false.obs;
  final videoPath = ''.obs;
  final isPlaying = false.obs;

  @override
  void onInit() {
    super.onInit();

    initializeControllerFuture = _initializeCamera();
  }

  @override
  void onClose() {
    _cameraController?.dispose();
    videoPlayerController?.dispose();
    super.onClose();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        Get.snackbar('Error', 'No cameras available');
        throw Exception('No cameras available');
      }

      final firstCamera = cameras.first;
      _cameraController = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );

      await _cameraController!.initialize();
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize camera: $e');

      rethrow;
    }
  }

  Future<void> startVideoRecording() async {
    await initializeControllerFuture;

    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      Get.snackbar('Error', 'Camera is not initialized.');
      return;
    }

    if (_cameraController!.value.isRecordingVideo) {
      return; // A recording is already in progress.
    }

    try {
      await _cameraController!.startVideoRecording();
      isRecording.value = true;
      debugPrint('Video recording started');
      update();
    } on CameraException catch (e) {
      Get.snackbar(
        'Error',
        'Failed to start video recording: ${e.description}',
      );
    }
  }

  Future<void> stopVideoRecording() async {
    if (_cameraController == null ||
        !_cameraController!.value.isRecordingVideo) {
      debugPrint('No recording in progress to stop.');
      // No recording in progress.
      return;
    }

    try {
      final file = await _cameraController!.stopVideoRecording();
      isRecording.value = false;
      videoPath.value = file.path;
      debugPrint('Video recorded to: ${file.path}');

      // Initialize video player to get duration
      final tempController = VideoPlayerController.file(File(file.path));
      debugPrint('Initializing temporary video player controller for duration');
      await tempController.initialize();
      debugPrint('Temporary video player initialized');
      final duration = tempController.value.duration;
      debugPrint('Video duration: $duration');
      await tempController.dispose();
      debugPrint('Temporary video player controller disposed');

      Get.find<HomeController>().saveVideo(
        VideoEntity(
          title: file.name,
          path: file.path,
          durationInMs: duration.inMilliseconds,
          createdAt: DateTime.now(),
        ),
      );

      _initializeVideoPlayer();
      update(); // Notify GetBuilder to rebuild the UI
    } on CameraException catch (e) {
      Get.snackbar('Error', 'Failed to stop video recording: ${e.description}');
    }
  }

  void _initializeVideoPlayer() {
    if (videoPath.value.isNotEmpty) {
      debugPrint('Initializing video player for: ${videoPath.value}');
      videoPlayerController?.dispose(); // Dispose previous controller if any
      videoPlayerController = VideoPlayerController.file(File(videoPath.value))
        ..initialize()
            .then((_) {
              debugPrint('Video player initialized successfully');
              if (videoPlayerController != null) {
                videoPlayerController!.play();
                isPlaying.value = true;
                videoPlayerController!.setLooping(true);
                debugPrint('Video player started playing');
              }
              update(); // Notify GetBuilder after initialization is complete
            })
            .catchError((error) {
              debugPrint('Failed to initialize video player: $error');
              Get.snackbar(
                'Error',
                'Failed to initialize video player: $error',
              );
            });
    }
  }

  void togglePlayPause() {
    if (videoPlayerController == null) return;

    if (videoPlayerController!.value.isPlaying) {
      videoPlayerController!.pause();
      isPlaying.value = false;
    } else {
      videoPlayerController!.play();
      isPlaying.value = true;
    }
    update(); // Notify GetBuilder to update play/pause button
  }

  void reset() {
    debugPrint('Resetting video controller');
    videoPlayerController?.dispose();
    videoPlayerController = null;
    videoPath.value = '';
    isPlaying.value = false;
    isRecording.value = false;

    update(); // Notify GetBuilder to rebuild the UI
  }
}
