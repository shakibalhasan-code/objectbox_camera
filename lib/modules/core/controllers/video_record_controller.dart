import 'dart:io';

import 'package:camera/camera.dart';
import 'package:crud_objtbx/modules/core/controllers/home_controller.dart';
import 'package:crud_objtbx/modules/core/models/video_entity.dart';
import 'package:crud_objtbx/modules/core/repo/video_repo.dart';
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
      // No recording in progress.
      return;
    }

    try {
      final file = await _cameraController!.stopVideoRecording();
      isRecording.value = false;
      videoPath.value = file.path;

      // Initialize video player to get duration
      final tempController = VideoPlayerController.file(File(file.path));
      await tempController.initialize();
      final duration = tempController.value.duration;
      await tempController.dispose();

      Get.find<HomeController>().saveVideo(
        VideoEntity(
          title: file.name,
          path: file.path,
          durationInMs: duration.inMilliseconds,
          createdAt: DateTime.now(),
        ),
      );

      _initializeVideoPlayer();
    } on CameraException catch (e) {
      Get.snackbar('Error', 'Failed to stop video recording: ${e.description}');
    }
  }

  void _initializeVideoPlayer() {
    if (videoPath.isNotEmpty) {
      videoPlayerController = VideoPlayerController.file(File(videoPath.value))
        ..initialize()
            .then((_) {
              update();
              if (videoPlayerController != null) {
                videoPlayerController!.play();
                isPlaying.value = true;
                videoPlayerController!.setLooping(true);
              }
            })
            .catchError((error) {
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
  }

  void reset() {
    videoPlayerController?.dispose();
    videoPlayerController = null;
    videoPath.value = '';
    isPlaying.value = false;

    update();
  }
}
