// 📦 Package imports:
import 'package:meta/meta.dart';

class ReviewModel {
  final String id;
  final String author;
  final String content;
  final int rating;
  ReviewModel({
    @required this.id,
    @required this.author,
    @required this.content,
    @required this.rating,
  });
}
