import 'package:crud_objtbx/modules/core/controllers/video_player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatelessWidget {
  final String videoPath;
  const CustomVideoPlayer({super.key, required this.videoPath});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomVideoPlayerController>(
      init: CustomVideoPlayerController()..initializePlayer(videoPath),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // Video Player
              Center(
                child: FutureBuilder(
                  future: controller.initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        controller.isInitialized.value &&
                        controller.controller != null) {
                      return AspectRatio(
                        aspectRatio: controller.controller!.value.aspectRatio,
                        child: VideoPlayer(controller.controller!),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              // Back button
              Positioned(
                top: 50,
                left: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                ),
              ),
              // Play/Pause button overlay
              Positioned.fill(
                child: GestureDetector(
                  onTap: controller.togglePlayPause,
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: Obx(
                        () => AnimatedOpacity(
                          opacity: controller.isPlaying.value ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Icon(
                              controller.isPlaying.value
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Video controls overlay
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Obx(
                          () => IconButton(
                            icon: Icon(
                              controller.isPlaying.value
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: controller.togglePlayPause,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
