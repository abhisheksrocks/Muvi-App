// 🎯 Dart imports:
import 'dart:async';

// 📦 Package imports:
import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:meta/meta.dart';

// 🌎 Project imports:
import '../models/movie_bucket.dart';
import '../repositories/movie_repository.dart';

part 'movie_cast_fetcher_state.dart';

class MovieCastFetcherCubit extends Cubit<MovieCastFetcherState> {
  final int movieId;
  int timeoutSeconds = 10;

  Connectivity _connectivity = Connectivity();
  StreamSubscription _connectivitySubscription;

  DataConnectionChecker _dataConnectionChecker = DataConnectionChecker()
    ..checkInterval = Duration(seconds: 1);
  StreamSubscription _dataSubscription;

  CancelableOperation gettingCastInfoHandler;

  MovieCastFetcherCubit({
    @required this.movieId,
  }) : super(MovieCastFetcherLoading()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (_connectivityResult) {
        // print(
        //     "ConnectivityResult @ MovieCastFetcherCubit: $_connectivityResult");
        if (_connectivityResult != ConnectivityResult.none) {
          if (state is MovieCastFetcherFailed) {
            _dataSubscription = _dataConnectionChecker.onStatusChange.listen(
              (_dataConnectionStatus) {
                if (_dataConnectionStatus == DataConnectionStatus.connected) {
                  // print("Starting MovieCastFetcherCubit Loading");
                  getCastInfo();
                  _dataSubscription.cancel();
                }
              },
            );
          }
        }
      },
    );

    getCastInfo();
  }

  void research() {
    getCastInfo();
  }

  void getCastInfo() {
    emitLoadingState();
    List<String> _listOfCasts = MovieBucket().getInfo(movieId).casts;
    if (_listOfCasts == null || _listOfCasts.isEmpty) {
      // print("Cast details not present");
      gettingCastInfoHandler?.cancel();
      gettingCastInfoHandler = CancelableOperation.fromFuture(
        MovieRepository().getCastInfo(movieId: movieId),
        onCancel: () {
          // print('gettingCastInfoHandler cancelled');
        },
      );

      gettingCastInfoHandler.value.then((value) {
        List<String> result = value as List<String>;
        emit(MovieCastFetcherLoaded(listOfCasts: result));
      }).catchError((_) {
        emit(MovieCastFetcherFailed());
      });
    } else {
      // print("Cast details is present");
      emit(
        MovieCastFetcherLoaded(
          listOfCasts: _listOfCasts,
        ),
      );
    }
  }

  Future<void> emitLoadingState() async {
    emit(MovieCastFetcherLoading());
    await Future.delayed(Duration(seconds: timeoutSeconds));
    if (state is MovieCastFetcherLoading) {
      emit(MovieCastFetcherLoading(timeoutExhausted: true));
    }
  }

  @override
  Future<void> close() {
    gettingCastInfoHandler?.cancel();
    _connectivitySubscription?.cancel();
    _dataSubscription?.cancel();
    return super.close();
  }
}
