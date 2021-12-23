// 🌎 Project imports:
import 'person_model.dart';

class PersonBucket {
  static List<PersonModel> _personList = [];

  PersonModel addPerson({
    required int id,
    required String name,
    String? avatarPath,
  }) {
    try {
      PersonModel _person =
          _personList.firstWhere((element) => element.id == id);
      _person.avatarPath = avatarPath ?? _person.avatarPath;
    } catch (_) {
      _personList.add(PersonModel(
        id: id,
        name: name,
        avatarPath: avatarPath,
      ));
    }
    return _personList.firstWhere((element) => element.id == id);
  }

  PersonModel getPerson({
    required int id,
  }) {
    return _personList.firstWhere((element) => element.id == id);
  }
}
