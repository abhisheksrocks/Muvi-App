class VideoModel {
  final String id;
  final String? path;
  final String title;
  final String provider;
  VideoModel({
    required this.id,
    this.path,
    required this.title,
    required this.provider,
  });
}
