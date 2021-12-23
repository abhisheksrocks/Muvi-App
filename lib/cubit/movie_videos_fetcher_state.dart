part of 'movie_videos_fetcher_cubit.dart';

@immutable
abstract class MovieVideosFetcherState {}

class MovieVideosFetcherLoading extends MovieVideosFetcherState {
  final bool timeoutExhausted;
  MovieVideosFetcherLoading({
    this.timeoutExhausted = false,
  });
}

class MovieVideosFetcherLoaded extends MovieVideosFetcherState {
  final List<String> listOfVideos;
  MovieVideosFetcherLoaded({
    required this.listOfVideos,
  });
}

class MovieVideosFetcherFailed extends MovieVideosFetcherState {}
