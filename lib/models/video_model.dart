// 📦 Package imports:
import 'package:meta/meta.dart';

class VideoModel {
  final String id;
  final String path;
  final String title;
  final String provider;
  VideoModel({
    @required this.id,
    @required this.path,
    @required this.title,
    @required this.provider,
  });
}
