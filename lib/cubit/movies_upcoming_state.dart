part of 'movies_upcoming_cubit.dart';

@immutable
abstract class MoviesUpcomingState {}

class MoviesUpcomingLoading extends MoviesUpcomingState {
  final bool timeoutExhausted;
  MoviesUpcomingLoading({
    this.timeoutExhausted = false,
  });
}

class MoviesUpcomingLoaded extends MoviesUpcomingState {
  final bool isAllLoaded;
  MoviesUpcomingLoaded({
    this.isAllLoaded = false,
  });
}

class MoviesUpcomingFailed extends MoviesUpcomingState {}
