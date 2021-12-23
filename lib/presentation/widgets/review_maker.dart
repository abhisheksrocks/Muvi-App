// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:shimmer/shimmer.dart';

// 🌎 Project imports:
import '../../cubit/movie_reviews_fetcher_cubit.dart';
import '../../models/review_bucket.dart';
import '../../models/review_model.dart';
import '../core/app_style.dart';
import 'loading_timeout_overlay.dart';
import 'network_error_overlay.dart';
import 'no_elements_overlay.dart';
import 'review_background_all_conditions.dart';
import 'review_individual.dart';

class ReviewMaker extends StatelessWidget {
  final MovieReviewsFetcherCubit parentCubit;
  ReviewMaker({
    Key? key,
    required this.parentCubit,
  }) : super(key: key);

  ReviewModel getReview({required MovieReviewsFetcherLoaded state}) {
    List<ReviewModel> _list = [];
    ReviewBucket _reviewBucket = ReviewBucket();
    state.listOfReviews.forEach((element) {
      _list.add(_reviewBucket.getReview(reviewId: element));
    });
    _list.sort((a, b) {
      if (a.rating == null) {
        return -1000;
      } else if (b.rating == null) {
        return 1000;
      }
      return a.rating!.compareTo(b.rating!);
    });
    // while (true) {
    // _list.forEach((element) {
    //   print(element.author);
    // });
    if (_list.length > 2) return _list.elementAt(_list.length - 2);
    return _list.last;

    // }
  }

  Widget childSwitcher({required BuildContext context}) {
    var state = parentCubit.state;
    // print(state);
    if (state is MovieReviewsFetcherLoaded) {
      if (state.listOfReviews.length == 0) {
        return Stack(
          key: ValueKey(1),
          alignment: Alignment.center,
          children: [
            ShaderMask(
              shaderCallback: AppStyle().defaultPosterShader,
              child: ReviewBackgroundAllConditions(
                foregroundColor: Colors.grey.withOpacity(0.2),
              ),
            ),
            NoElementsOverlay(),
          ],
        );
      }
      return ReviewIndividual(
        key: ValueKey(2),
        reviewModel: getReview(state: state),
      );
    } else if (state is MovieReviewsFetcherLoading) {
      return Stack(
        key: ValueKey(4),
        alignment: Alignment.center,
        children: [
          Shimmer.fromColors(
            key: ValueKey(4),
            baseColor: Colors.white12,
            highlightColor: Colors.white38,
            child: ReviewBackgroundAllConditions(),
          ),
          if (state.timeoutExhausted)
            LoadingTimeoutOverlay(functionToExecute: parentCubit.research)
        ],
      );
    }
    //For Failed State:-
    return Stack(
      key: ValueKey(3),
      alignment: Alignment.center,
      children: [
        ReviewBackgroundAllConditions(
          foregroundColor: Colors.grey.withOpacity(0.2),
        ),
        NetworkErrorOverlay(
          functionToExecute: parentCubit.research,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(seconds: 1),
      child: childSwitcher(context: context),
    );
  }
}
