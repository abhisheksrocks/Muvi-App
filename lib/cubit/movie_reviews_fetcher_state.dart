part of 'movie_reviews_fetcher_cubit.dart';

@immutable
abstract class MovieReviewsFetcherState {}

class MovieReviewsFetcherLoading extends MovieReviewsFetcherState {
  final bool timeoutExhausted;
  MovieReviewsFetcherLoading({
    this.timeoutExhausted = false,
  });
}

class MovieReviewsFetcherLoaded extends MovieReviewsFetcherState {
  final List<String> listOfReviews;
  MovieReviewsFetcherLoaded({
    required this.listOfReviews,
  });
}

class MovieReviewsFetcherFailed extends MovieReviewsFetcherState {}
