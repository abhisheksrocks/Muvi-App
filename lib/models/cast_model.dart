// 📦 Package imports:
import 'package:meta/meta.dart';

// 🌎 Project imports:
import 'person_model.dart';

class CastModel {
  String creditId;
  PersonModel person;
  String characterName;

  CastModel({
    @required this.creditId,
    @required this.person,
    @required this.characterName,
  });
}
