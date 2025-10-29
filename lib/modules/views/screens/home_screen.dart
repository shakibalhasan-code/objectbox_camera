import 'package:crud_objtbx/modules/core/controllers/home_controller.dart';
import 'package:crud_objtbx/modules/screens/video_recording_screen.dart';
import 'package:crud_objtbx/modules/views/widgets/custom_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          body: Obx(() {
            if (controller.videoList.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text('No videos recorded yet.')),
                  SizedBox(height: 10),
                  Center(
                    child: Text('Tap the button below to record a video.'),
                  ),
                  SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () => Get.to(VideoRecordingScreen()),
                    child: Text('Record Video'),
                  ),
                ],
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: controller.videoList.length,
                itemBuilder: (context, index) {
                  final video = controller.videoList[index];
                  return ListTile(
                    tileColor: Colors.grey[200], // Set background color here

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    onTap: () =>
                        Get.to(CustomVideoPlayer(videoPath: video.path)),
                    title: Text(video.title),
                    subtitle: Text(
                      'Recorded on: ${video.createdAt}\n'
                      'Duration: ${(video.durationInMs / 1000).toStringAsFixed(2)} seconds\n'
                      'Saved at: ${video.path}',
                    ),

                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => controller.deleteVideo(video.id),
                    ),
                  );
                },
              ),
            );
          }),
          floatingActionButton: controller.videoList.isNotEmpty
              ? SizedBox(
                  width: Get.width * 0.6,
                  child: FloatingActionButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),

                    onPressed: () => Get.to(VideoRecordingScreen()),
                    child: Text('Record New Video'),
                  ),
                )
              : null,
        );
      },
    );
  }
}
