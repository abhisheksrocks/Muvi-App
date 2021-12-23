part of 'movie_cast_fetcher_cubit.dart';

@immutable
abstract class MovieCastFetcherState {}

class MovieCastFetcherLoading extends MovieCastFetcherState {
  final bool timeoutExhausted;

  MovieCastFetcherLoading({
    this.timeoutExhausted = false,
  });
}

class MovieCastFetcherLoaded extends MovieCastFetcherState {
  final List<String> listOfCasts;
  MovieCastFetcherLoaded({
    required this.listOfCasts,
  });
}

class MovieCastFetcherFailed extends MovieCastFetcherState {}
