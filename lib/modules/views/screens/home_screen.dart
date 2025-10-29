import 'package:crud_objtbx/modules/core/controllers/home_controller.dart';
import 'package:crud_objtbx/modules/views/screens/video_recording_screen.dart';
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
          appBar: AppBar(
            title: const Text('Video Library'),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          body: controller.videoList.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.videocam_off,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Center(child: Text('No videos recorded yet.')),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text('Tap the button below to record a video.'),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () =>
                          Get.to(() => const VideoRecordingScreen()),
                      child: const Text('Record Video'),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: controller.videoList.length,
                    itemBuilder: (context, index) {
                      final video = controller.videoList[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          tileColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          leading: const Icon(
                            Icons.video_library,
                            color: Colors.blue,
                          ),
                          onTap: () => Get.to(
                            () => CustomVideoPlayer(videoPath: video.path),
                          ),
                          title: Text(
                            video.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Recorded: ${_formatDateTime(video.createdAt)}\n'
                            'Duration: ${(video.durationInMs / 1000).toStringAsFixed(1)}s',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _showDeleteConfirmation(
                              context,
                              controller,
                              video.id,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Get.to(() => const VideoRecordingScreen()),
            label: const Text('Record Video'),
            icon: const Icon(Icons.videocam),
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showDeleteConfirmation(
    BuildContext context,
    HomeController controller,
    int videoId,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Video'),
          content: const Text('Are you sure you want to delete this video?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.deleteVideo(videoId);
                Navigator.of(context).pop();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
