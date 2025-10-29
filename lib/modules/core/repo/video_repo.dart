import 'package:crud_objtbx/main.dart';
import 'package:crud_objtbx/modules/core/models/video_entity.dart';
import 'package:flutter/foundation.dart';

class VideoRepo {
  Future<List<VideoEntity>> getVideos() async {
    return objectbox.videoBox.getAll();
  }

  Future<void> saveVideo(VideoEntity video) async {
    await objectbox.put(video);
    debugPrint('>>>>>>>>>>>> Video saved at path: ${video.path}');
  }

  Future<void> deleteVideo(int id) async {
    await objectbox.remove<VideoEntity>(id);
    debugPrint('>>>>>>>>>>>> Video deleted with id: $id');
  }

  Stream<List<VideoEntity>> getVideoStream() {
    return objectbox.getStream<VideoEntity>();
  }
}
