import 'package:crud_objtbx/modules/core/models/video_entity.dart';
import 'package:crud_objtbx/modules/core/repo/video_repo.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  List<VideoEntity> videoList = <VideoEntity>[];

  final videoRepo = Get.find<VideoRepo>();

  @override
  void onInit() {
    super.onInit();
    fetchVideos();
  }

  void fetchVideos() async {
    videoList = await videoRepo.getVideos();
    update(); // Notify GetBuilder to rebuild
  }

  void saveVideo(VideoEntity video) async {
    await videoRepo.saveVideo(video);
    fetchVideos();
  }

  void deleteVideo(int id) async {
    await videoRepo.deleteVideo(id);
    fetchVideos();
  }
}
