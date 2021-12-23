// 🌎 Project imports:
import 'person_model.dart';

class CastModel {
  String creditId;
  PersonModel person;
  String? characterName;

  CastModel({
    required this.creditId,
    required this.person,
    this.characterName,
  });
}
