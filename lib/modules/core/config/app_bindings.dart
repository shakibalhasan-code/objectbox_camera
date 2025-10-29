import 'package:crud_objtbx/modules/core/controllers/home_controller.dart';
import 'package:crud_objtbx/modules/core/controllers/video_record_controller.dart';
import 'package:crud_objtbx/modules/core/controllers/video_player_controller.dart';
import 'package:crud_objtbx/modules/core/repo/video_repo.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Controllers
    Get.lazyPut<VideoController>(() => VideoController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CustomVideoPlayerController>(
      () => CustomVideoPlayerController(),
      fenix: true,
    );

    /// initialize our repo
    VideoRepo videoRepo = VideoRepo();
    Get.put<VideoRepo>(videoRepo);
  }
}
