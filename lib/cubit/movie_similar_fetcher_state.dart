part of 'movie_similar_fetcher_cubit.dart';

@immutable
abstract class MoviesSimilarFetcherState {}

class MoviesSimilarFetcherLoading extends MoviesSimilarFetcherState {
  final bool timeoutExhausted;
  MoviesSimilarFetcherLoading({
    this.timeoutExhausted = false,
  });
}

class MoviesSimilarFetcherLoaded extends MoviesSimilarFetcherState {
  final bool isAllLoaded;
  MoviesSimilarFetcherLoaded({
    this.isAllLoaded = false,
  });
}

class MoviesSimilarFetcherFailed extends MoviesSimilarFetcherState {}
