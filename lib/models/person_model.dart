// 📦 Package imports:
import 'package:meta/meta.dart';

class PersonModel {
  int id;
  String name;
  String avatarPath;

  PersonModel({
    @required this.id,
    this.name,
    this.avatarPath,
  });
}
