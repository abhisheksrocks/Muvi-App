// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../cubit/movie_reviews_fetcher_cubit.dart';
import '../../models/review_bucket.dart';
import '../../models/review_model.dart';
import '../widgets/icon_maker.dart';
import '../widgets/review_individual.dart';

class ViewAllReviewsScreen extends StatefulWidget {
  final MovieReviewsFetcherLoaded state;

  const ViewAllReviewsScreen({
    Key key,
    @required this.state,
  }) : super(key: key);

  @override
  _ViewAllReviewsScreenState createState() => _ViewAllReviewsScreenState();
}

class _ViewAllReviewsScreenState extends State<ViewAllReviewsScreen> {
  ReviewBucket _reviewBucket = ReviewBucket();

  ReviewModel _reviewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconMaker(
          icon: Icon(Icons.arrow_back),
          functionToPerform: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'All Reviews',
          style: Theme.of(context).textTheme.headline1.apply(fontSizeDelta: 4),
        ),
      ),
      body: SingleChildScrollView(
        child: Wrap(
          runSpacing: 8,
          children: (widget.state.listOfReviews).map((reviewId) {
            _reviewModel = _reviewBucket.getReview(reviewId: reviewId);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  ReviewIndividual(
                    reviewModel: _reviewModel,
                  ),
                  Divider(),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
