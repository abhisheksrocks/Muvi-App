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

part 'movie_videos_fetcher_state.dart';

class MovieVideosFetcherCubit extends Cubit<MovieVideosFetcherState> {
  final int movieId;

  Connectivity _connectivity = Connectivity();
  StreamSubscription _connectivitySubscription;

  DataConnectionChecker _dataConnectionChecker = DataConnectionChecker()
    ..checkInterval = Duration(seconds: 1);
  StreamSubscription _dataSubscription;

  CancelableOperation getVideoInfoHandler;
  int timeoutSeconds = 10;

  MovieVideosFetcherCubit({
    @required this.movieId,
  }) : super(MovieVideosFetcherLoading()) {
    /*
    Use the following only in case when jub internet wapas aaye 
    after loading failed initially, because Connectivity() 
    doesn't always return current state
    */
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (_connectivityResult) {
        // print("ConnectivityResult @ MoviesUpcomingCubit: $_connectivityResult");
        if (_connectivityResult != ConnectivityResult.none) {
          if (state is MovieVideosFetcherFailed) {
            _dataSubscription = _dataConnectionChecker.onStatusChange.listen(
              (_dataConnectionStatus) {
                if (_dataConnectionStatus == DataConnectionStatus.connected) {
                  // print("Starting MoviesUpcomingCubit Loading");
                  getVideosInfo();
                  _dataSubscription.cancel();
                }
              },
            );
          }
        }
      },
    );

    getVideosInfo();
  }

  void getVideosInfo() {
    emitLoadingState();
    List<String> _listOfVideos = MovieBucket().getInfo(movieId).videos;
    if (_listOfVideos == null || _listOfVideos.isEmpty) {
      // print("Cast details not present");
      getVideoInfoHandler?.cancel();
      getVideoInfoHandler = CancelableOperation.fromFuture(
        MovieRepository().getVideos(movieId: movieId),
        onCancel: () {
          // print('getVideoInfoHandler cancelled');
        },
      );

      getVideoInfoHandler.value.then((value) {
        List<String> result = value as List<String>;
        emit(MovieVideosFetcherLoaded(listOfVideos: result));
      }).catchError((_) {
        emit(MovieVideosFetcherFailed());
      });
    } else {
      // print("Cast details is present");
      emit(
        MovieVideosFetcherLoaded(
          listOfVideos: _listOfVideos,
        ),
      );
    }
  }

  Future<void> emitLoadingState() async {
    emit(MovieVideosFetcherLoading());
    await Future.delayed(Duration(seconds: timeoutSeconds));
    if (state is MovieVideosFetcherLoading) {
      emit(MovieVideosFetcherLoading(timeoutExhausted: true));
    }
  }

  void research() {
    getVideosInfo();
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _dataSubscription?.cancel();
    return super.close();
  }
}
