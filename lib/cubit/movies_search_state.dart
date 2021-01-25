part of 'movies_search_cubit.dart';

@immutable
abstract class MoviesSearchState {}

class MoviesSearchEmptyQuery extends MoviesSearchState {}

class MoviesSearchLoading extends MoviesSearchState {
  final bool timeoutExhausted;
  MoviesSearchLoading({
    this.timeoutExhausted = false,
  });
}

class MoviesSearchLoaded extends MoviesSearchState {
  final bool isAllLoaded;
  MoviesSearchLoaded({
    this.isAllLoaded = false,
  });
}

class MoviesSearchFailed extends MoviesSearchState {}
