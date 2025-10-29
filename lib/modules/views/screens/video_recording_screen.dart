import 'package:camera/camera.dart';
import 'package:crud_objtbx/modules/core/controllers/video_record_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoRecordingScreen extends StatelessWidget {
  const VideoRecordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoController>(
      init: VideoController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('ObjBox CRUD')),
          body: FutureBuilder<void>(
            future: controller.initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Show recorded video if available
                return Obx(() {
                  if (controller.videoPath.value.isNotEmpty) {
                    return Container(
                      color: Colors.black,
                      child: Stack(
                        children: [
                          // Video Player
                          Center(
                            child:
                                controller.videoPlayerController != null &&
                                    controller
                                        .videoPlayerController!
                                        .value
                                        .isInitialized
                                ? AspectRatio(
                                    aspectRatio: controller
                                        .videoPlayerController!
                                        .value
                                        .aspectRatio,
                                    child: VideoPlayer(
                                      controller.videoPlayerController!,
                                    ),
                                  )
                                : const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                          ),
                          // Play/Pause button overlay
                          Positioned(
                            bottom: 100,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: Obx(
                                  () => IconButton(
                                    icon: Icon(
                                      controller.isPlaying.value
                                          ? Icons.pause_circle
                                          : Icons.play_circle,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                    onPressed: controller.togglePlayPause,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Show camera preview
                  if (controller.cameraController != null &&
                      controller.cameraController!.value.isInitialized) {
                    return CameraPreview(controller.cameraController!);
                  }

                  return const Center(child: CircularProgressIndicator());
                });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (controller.videoPath.value.isNotEmpty) {
                controller.reset();
                return;
              }

              if (controller.isRecording.value) {
                controller.stopVideoRecording();
              } else {
                controller.startVideoRecording();
              }
            },
            child: Obx(() => _buildFabIcon(controller)),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  Widget _buildFabIcon(VideoController controller) {
    if (controller.videoPath.value.isNotEmpty) {
      return const Icon(Icons.refresh); // Reset icon
    }
    return Icon(controller.isRecording.value ? Icons.stop : Icons.videocam);
  }
}
