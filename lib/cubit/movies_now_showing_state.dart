part of 'movies_now_showing_cubit.dart';

@immutable
abstract class MoviesNowShowingState {}

class MoviesNowShowingLoading extends MoviesNowShowingState {
  final bool timeoutExhausted;
  MoviesNowShowingLoading({
    this.timeoutExhausted = false,
  });
}

class MoviesNowShowingLoaded extends MoviesNowShowingState {
  final bool isAllLoaded;
  MoviesNowShowingLoaded({
    this.isAllLoaded = false,
  });
}

class MoviesNowShowingFailed extends MoviesNowShowingState {}
