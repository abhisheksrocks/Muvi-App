// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../models/review_model.dart';
import 'horizontal_divider_small.dart';
import 'rating_with_text.dart';
import 'summary_review_text.dart';

class ReviewIndividual extends StatelessWidget {
  const ReviewIndividual({
    Key? key,
    required this.reviewModel,
  }) : super(key: key);

  final ReviewModel reviewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'by ', style: Theme.of(context).textTheme.overline),
                TextSpan(
                  text: "${reviewModel.author}",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ]),
            ),
            if (reviewModel.rating != null) HorizontalDividerSmall(),
            if (reviewModel.rating != null)
              RatingWithText(
                avgRatingOutOfTen: reviewModel.rating!.toDouble(),
              ),
          ],
        ),
        SummaryReviewText(
          key: ValueKey('Review'),
          textData: '${reviewModel.content}',
          textStyle: Theme.of(context).textTheme.bodyText1!,
          linesToShow: 20,
        ),
      ],
    );
  }
}
