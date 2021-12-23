// 🌎 Project imports:
import 'video_model.dart';

class VideoBucket {
  static List<VideoModel> _listOfVideos = [];

  void addVideo({
    required String id,
    required String path,
    required String title,
    required String provider,
  }) {
    try {
      _listOfVideos.firstWhere((element) => element.id == id);
    } catch (_) {
      _listOfVideos.add(VideoModel(
        id: id,
        path: path,
        provider: provider,
        title: title,
      ));
    }
  }

  VideoModel getVideo({
    required String id,
  }) {
    return _listOfVideos.firstWhere((element) => element.id == id);
  }
}
