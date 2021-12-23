// 📦 Package imports:
import 'package:intl/intl.dart';

// 🌎 Project imports:
import 'movie_model.dart';

class MovieBucket {
  static List<MovieModel> _listOfMovies = [];

  void addInfo({
    required int id,
    String? posterImagePath,
    String? title,
    String? summary,
    String? releaseDate,
    List<int>? genreIds,
    double? avgRatingOutOfTen,
    int? totalRatingCount,
    List<String>? casts,
    List<String>? videos,
    List<String>? reviews,
    List<int>? similarMovies,
    String? certification,
    int? runtimeMinutes,
  }) {
    try {
      MovieModel movie =
          _listOfMovies.firstWhere((element) => element.id == id);
      movie.posterImagePath = posterImagePath ?? movie.posterImagePath;
      movie.title = title ?? movie.title;
      movie.summary = summary ?? movie.summary;
      movie.releaseDate = (releaseDate == null || releaseDate == "")
          ? movie.releaseDate
          : DateFormat('yyyy-MM-dd').parse(releaseDate);
      movie.genreIds = genreIds ?? movie.genreIds;
      movie.avgRatingOutOfTen = avgRatingOutOfTen ?? movie.avgRatingOutOfTen;
      movie.totalRatingCount = totalRatingCount ?? movie.totalRatingCount;
      movie.casts = casts ?? movie.casts;
      movie.videos = videos ?? movie.videos;
      movie.reviews = reviews ?? movie.reviews;
      movie.similarMovies = similarMovies ?? movie.similarMovies;
      movie.certification = certification ?? movie.certification;
      movie.runtimeMinutes = runtimeMinutes ?? movie.runtimeMinutes;
    } catch (_) {
      _listOfMovies.add(
        MovieModel(
          id: id,
          genreIds: genreIds,
          posterImagePath: posterImagePath,
          releaseDate: (releaseDate == null || releaseDate == "")
              ? null
              : DateFormat('yyyy-MM-dd').parse(releaseDate),
          summary: summary,
          title: title,
          avgRatingOutOfTen: avgRatingOutOfTen,
          totalRatingCount: totalRatingCount,
          casts: casts,
          videos: videos,
          reviews: reviews,
          similarMovies: similarMovies,
          certification: certification,
          runtimeMinutes: runtimeMinutes,
        ),
      );
    }
  }

  MovieModel getInfo(int id) {
    return _listOfMovies.firstWhere((element) => element.id == id);
  }
}
