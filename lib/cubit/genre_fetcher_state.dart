part of 'genre_fetcher_cubit.dart';

@immutable
abstract class GenreFetcherState {}

class GenreFetcherLoading extends GenreFetcherState {}

class GenreFetcherLoaded extends GenreFetcherState {}

class GenreFetcherFailed extends GenreFetcherState {}
