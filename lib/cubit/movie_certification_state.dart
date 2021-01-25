part of 'movie_certification_cubit.dart';

@immutable
abstract class MovieCertificationState {}

class MovieCertificationLoading extends MovieCertificationState {
  final bool timeoutExhausted;
  MovieCertificationLoading({
    this.timeoutExhausted = false,
  });
}

class MovieCertificationLoaded extends MovieCertificationState {
  final String certificate;
  MovieCertificationLoaded({
    @required this.certificate,
  });
}

class MovieCertificationFailed extends MovieCertificationState {}
