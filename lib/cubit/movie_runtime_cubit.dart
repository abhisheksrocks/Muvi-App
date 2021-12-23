// 🎯 Dart imports:
import 'dart:async';

// 📦 Package imports:
import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// 🌎 Project imports:
import '../models/movie_bucket.dart';
import '../repositories/movie_repository.dart';

part 'movie_runtime_state.dart';

class MovieRuntimeCubit extends Cubit<MovieRuntimeState> {
  final int movieId;
  int timeoutSeconds = 10;

  Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;

  InternetConnectionChecker _dataConnectionChecker = InternetConnectionChecker()
    ..checkInterval = Duration(seconds: 1);
  StreamSubscription? _dataSubscription;

  CancelableOperation? getRuntimeMinutesHandler;

  MovieRuntimeCubit({
    required this.movieId,
  }) : super(MovieRuntimeLoading()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (_connectivityResult) {
        // print("ConnectivityResult @ MovieRuntimeCubit: $_connectivityResult");
        if (_connectivityResult != ConnectivityResult.none) {
          if (state is MovieRuntimeFailed) {
            _dataSubscription = _dataConnectionChecker.onStatusChange.listen(
              (_dataConnectionStatus) {
                if (_dataConnectionStatus ==
                    InternetConnectionStatus.connected) {
                  // print("Starting MovieRuntimeCubit Loading");
                  getRuntimeInfo();
                  _dataSubscription?.cancel();
                }
              },
            );
          }
        }
      },
    );

    getRuntimeInfo();
  }

  void research() {
    getRuntimeInfo();
  }

  String minutesToHhMm(int minutes) {
    int hrs = minutes ~/ 60;
    int min = minutes % 60;
    String resultToReturn = '';
    if (hrs != 0) {
      resultToReturn = "${hrs}h ";
    }
    resultToReturn = "$resultToReturn $min min";
    return resultToReturn;
  }

  void getRuntimeInfo() {
    emitLoadingState();
    int? _runtimeMinutes = MovieBucket().getInfo(movieId).runtimeMinutes;
    if (_runtimeMinutes == null) {
      // print("Cast details not present");
      getRuntimeMinutesHandler?.cancel();
      getRuntimeMinutesHandler = CancelableOperation.fromFuture(
        MovieRepository().getMovieRuntime(movieId: movieId),
        onCancel: () {
          // print('gettingCastInfoHandler cancelled');
        },
      );

      getRuntimeMinutesHandler?.value.then((value) {
        int result = value as int;
        emit(MovieRuntimeLoaded(runtimeMinutes: result));
      }).catchError((_) {
        emit(MovieRuntimeFailed());
      });
    } else {
      // print("Cast details is present");
      emit(
        MovieRuntimeLoaded(
          runtimeMinutes: _runtimeMinutes,
        ),
      );
    }
  }

  Future<void> emitLoadingState() async {
    emit(MovieRuntimeLoading());
    await Future.delayed(Duration(seconds: timeoutSeconds));
    if (state is MovieRuntimeLoading) {
      emit(MovieRuntimeLoading(timeoutExhausted: true));
    }
  }

  @override
  Future<void> close() {
    getRuntimeMinutesHandler?.cancel();
    _connectivitySubscription?.cancel();
    _dataSubscription?.cancel();
    return super.close();
  }
}
