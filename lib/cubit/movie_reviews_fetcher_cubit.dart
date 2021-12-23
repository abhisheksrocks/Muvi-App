// 🎯 Dart imports:
import 'dart:async';

// 📦 Package imports:
import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';

// 🌎 Project imports:
import '../models/movie_bucket.dart';
import '../repositories/movie_repository.dart';

part 'movie_reviews_fetcher_state.dart';

class MovieReviewsFetcherCubit extends Cubit<MovieReviewsFetcherState> {
  final int movieId;

  Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;

  InternetConnectionChecker _dataConnectionChecker = InternetConnectionChecker()
    ..checkInterval = Duration(seconds: 1);
  StreamSubscription? _dataSubscription;

  CancelableOperation? getReviewInfoHandler;
  int timeoutSeconds = 10;

  MovieReviewsFetcherCubit({
    required this.movieId,
  }) : super(MovieReviewsFetcherLoading()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (_connectivityResult) {
        // print(
        //     "ConnectivityResult @ MovieReviewsFetcherCubit: $_connectivityResult");
        if (_connectivityResult != ConnectivityResult.none) {
          if (state is MovieReviewsFetcherFailed) {
            _dataSubscription = _dataConnectionChecker.onStatusChange.listen(
              (_dataConnectionStatus) {
                if (_dataConnectionStatus ==
                    InternetConnectionStatus.connected) {
                  // print("Starting MovieReviewsFetcherCubit Loading");
                  getReviewInfo();
                  _dataSubscription?.cancel();
                }
              },
            );
          }
        }
      },
    );
    getReviewInfo();
  }

  void getReviewInfo() {
    emitLoadingState();
    List<String>? _listOfReviews = MovieBucket().getInfo(movieId).reviews;
    if (_listOfReviews == null || _listOfReviews.isEmpty) {
      // print("Cast details not present");
      getReviewInfoHandler?.cancel();
      getReviewInfoHandler = CancelableOperation.fromFuture(
        MovieRepository().getReviews(movieId: movieId),
        onCancel: () {
          // print('gettingCastInfoHandler cancelled');
        },
      );

      getReviewInfoHandler?.value.then((value) {
        List<String> result = value as List<String>;
        emit(MovieReviewsFetcherLoaded(listOfReviews: result));
      }).catchError((_) {
        emit(MovieReviewsFetcherFailed());
      });
    } else {
      // print("Cast details is present");
      emit(
        MovieReviewsFetcherLoaded(
          listOfReviews: _listOfReviews,
        ),
      );
    }
  }

  void research() {
    getReviewInfo();
  }

  Future<void> emitLoadingState() async {
    emit(MovieReviewsFetcherLoading());
    await Future.delayed(Duration(seconds: timeoutSeconds));
    if (state is MovieReviewsFetcherLoading) {
      emit(MovieReviewsFetcherLoading(timeoutExhausted: true));
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _dataSubscription?.cancel();
    getReviewInfoHandler?.cancel();
    return super.close();
  }
}
