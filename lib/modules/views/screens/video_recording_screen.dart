import 'package:camera/camera.dart';
import 'package:crud_objtbx/modules/core/controllers/video_record_controller.dart';
import 'package:crud_objtbx/modules/views/widgets/custom_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoRecordingScreen extends StatelessWidget {
  const VideoRecordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VideoController controller = Get.find<VideoController>();

    return Scaffold(
      appBar: AppBar(title: const Text('ObjBox CRUD')),
      body: FutureBuilder<void>(
        future: controller.initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Obx(() {
              if (controller.videoPath.isNotEmpty) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: CustomVideoPlayer(
                        videoPath: controller.videoPath.value,
                      ),
                    ),

                    Positioned(
                      bottom: 20,
                      child: IconButton(
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
                  ],
                );
              } else {
                if (controller.cameraController == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return CameraPreview(controller.cameraController!);
              }
            });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (controller.videoPath.isNotEmpty) {
            controller.reset();
            return;
          }

          if (controller.isRecording.value) {
            controller.stopVideoRecording();
          } else {
            controller.startVideoRecording();
          }
        },
        child: Obx(() {
          if (controller.videoPath.isNotEmpty) {
            return const Icon(Icons.refresh); // Reset icon
          }
          return Icon(
            controller.isRecording.value ? Icons.stop : Icons.videocam,
          );
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
