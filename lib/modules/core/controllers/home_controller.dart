import 'package:crud_objtbx/main.dart';
import 'package:crud_objtbx/modules/core/models/video_entity.dart';
import 'package:crud_objtbx/modules/core/repo/video_repo.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final videoList = <VideoEntity>[].obs;

  final videoRepo = Get.find<VideoRepo>();
  @override
  void onInit() {
    super.onInit();
    fetchVideos();
  }

  void fetchVideos() async {
    videoList.value = await videoRepo.getVideos();
    update();
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
