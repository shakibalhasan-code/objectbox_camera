import 'dart:io';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  CameraController? get cameraController => _cameraController;

  CameraController? _cameraController;
  late Future<void> initializeControllerFuture;
  VideoPlayerController? videoPlayerController;

  final isRecording = false.obs;
  final videoPath = ''.obs;
  final isPlaying = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
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
        return;
      }
      final firstCamera = cameras.first;
      _cameraController = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );
      initializeControllerFuture = _cameraController!.initialize();
      await initializeControllerFuture; // Wait for initialization to complete
      update(); // Notify UI to rebuild
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize camera: $e');
    }
  }

  Future<void> startVideoRecording() async {
    if (_cameraController == null) return;

    // Ensure the camera is initialized
    await initializeControllerFuture;

    if (_cameraController!.value.isRecordingVideo) {
      return;
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
    if (_cameraController == null) return;

    if (!_cameraController!.value.isRecordingVideo) {
      // No recording to stop
      return;
    }

    try {
      final file = await _cameraController!.stopVideoRecording();
      isRecording.value = false;
      videoPath.value = file.path;
      _initializeVideoPlayer();
    } on CameraException catch (e) {
      Get.snackbar('Error', 'Failed to stop video recording: ${e.description}');
    }
  }

  void _initializeVideoPlayer() {
    if (videoPath.isNotEmpty) {
      videoPlayerController = VideoPlayerController.file(File(videoPath.value))
        ..initialize().then((_) {
          update();
          videoPlayerController?.play();
          isPlaying.value = true;
          videoPlayerController?.setLooping(true);
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
    update();
  }

  // A method to reset the state to record another video
  void reset() {
    videoPlayerController?.dispose();
    videoPlayerController = null;
    videoPath.value = '';
    isPlaying.value = false;
  }
}
