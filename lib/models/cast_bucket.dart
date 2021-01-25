// 📦 Package imports:
import 'package:meta/meta.dart';

// 🌎 Project imports:
import 'cast_model.dart';
import 'person_model.dart';

class CastBucket {
  static List<CastModel> _allCasts = [];

  void addCast({
    @required String creditId,
    @required PersonModel person,
    @required String characterName,
  }) {
    try {
      _allCasts.firstWhere((element) => element.creditId == creditId);
    } catch (_) {
      _allCasts.add(
        CastModel(
          characterName: characterName,
          person: person,
          creditId: creditId,
        ),
      );
    }
  }

  CastModel getCast({
    String creditId,
  }) {
    return _allCasts.firstWhere((element) => element.creditId == creditId);
  }
}
