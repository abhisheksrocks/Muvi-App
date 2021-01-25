// 📦 Package imports:
import 'package:meta/meta.dart';

// 🌎 Project imports:
import 'review_model.dart';

class ReviewBucket {
  static List<ReviewModel> _listOfReviews = [];

  void addReview({
    @required String id,
    @required String author,
    @required String content,
    @required int rating,
  }) {
    try {
      _listOfReviews.firstWhere((element) => element.id == id);
    } catch (_) {
      _listOfReviews.add(ReviewModel(
        id: id,
        author: author,
        content: content,
        rating: rating,
      ));
    }
  }

  ReviewModel getReview({
    @required String reviewId,
  }) {
    return _listOfReviews.firstWhere((element) => element.id == reviewId);
  }
}
