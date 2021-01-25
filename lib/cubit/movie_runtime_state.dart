part of 'movie_runtime_cubit.dart';

abstract class MovieRuntimeState {}

class MovieRuntimeLoading extends MovieRuntimeState {
  final bool timeoutExhausted;
  MovieRuntimeLoading({
    this.timeoutExhausted = false,
  });
}

class MovieRuntimeLoaded extends MovieRuntimeState {
  final int runtimeMinutes;
  String minutesInString;
  MovieRuntimeLoaded({
    @required this.runtimeMinutes,
  }) {
    int hrs = runtimeMinutes ~/ 60;
    int min = runtimeMinutes % 60;
    String resultToReturn = '';
    if (hrs != 0) {
      resultToReturn = "${hrs}h ";
    }
    resultToReturn = "$resultToReturn $min min";
    minutesInString = resultToReturn;
  }
}

class MovieRuntimeFailed extends MovieRuntimeState {}
