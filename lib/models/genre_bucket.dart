// 📦 Package imports:
import 'package:meta/meta.dart';

// 🌎 Project imports:
import 'genre_model.dart';

class GenreBucket {
  static List<GenreModel> _genresList = [];

  void addGenre({
    @required int id,
    @required String genre,
  }) {
    try {
      final result = _genresList.firstWhere((element) => element.id == id);
      result.genre = genre;
      return;
    } catch (_) {
      _genresList.add(GenreModel(genre: genre, id: id));
    }
  }

  String getGenre({
    @required int id,
  }) {
    try {
      return _genresList.firstWhere((element) => element.id == id).genre;
    } catch (_) {
      // print("Couldn't find Genre for ID: $id");
      return '';
    }
  }
}
