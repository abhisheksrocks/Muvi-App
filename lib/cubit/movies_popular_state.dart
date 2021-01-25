part of 'movies_popular_cubit.dart';

@immutable
abstract class MoviesPopularState {}

class MoviesPopularLoading extends MoviesPopularState {
  final bool timeoutExhausted;
  MoviesPopularLoading({
    this.timeoutExhausted = false,
  });
}

class MoviesPopularLoaded extends MoviesPopularState {
  final bool isAllLoaded;
  MoviesPopularLoaded({
    this.isAllLoaded = false,
  });
}

class MoviesPopularFailed extends MoviesPopularState {}
