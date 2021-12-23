class MovieModel {
  int id;
  String? posterImagePath;
  String? title;
  String? summary;
  DateTime? releaseDate;
  List<int>? genreIds;
  double? avgRatingOutOfTen;
  int? totalRatingCount;
  List<String>? casts;
  List<String>? videos;
  List<String>? reviews;
  List<int>? similarMovies;
  String? certification;
  int? runtimeMinutes;

  MovieModel({
    required this.id,
    this.posterImagePath,
    this.title,
    this.summary,
    this.releaseDate,
    this.genreIds,
    this.avgRatingOutOfTen,
    this.totalRatingCount,
    this.casts,
    this.videos,
    this.reviews,
    this.similarMovies,
    this.certification,
    this.runtimeMinutes,
  });
}
