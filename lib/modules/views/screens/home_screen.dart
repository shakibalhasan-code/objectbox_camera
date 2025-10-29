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
            return ListView.builder(
              itemCount: controller.videoList.length,
              itemBuilder: (context, index) {
                final video = controller.videoList[index];
                return ListTile(
                  onTap: () => Get.to(CustomVideoPlayer(videoPath: video.path)),
                  title: Text('Video ${index + 1}'),
                  subtitle: Text(
                    'Recorded on: ${video.createdAt}  Duration: ${(video.durationInMs / 1000).toStringAsFixed(2)} seconds',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => controller.deleteVideo(video.id),
                  ),
                );
              },
            );
          }),
        );
      },
    );
  }
}
