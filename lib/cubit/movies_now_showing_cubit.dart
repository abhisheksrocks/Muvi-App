// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';

// 📦 Package imports:
import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

// 🌎 Project imports:
import '../common/all_enums.dart';
import '../repositories/movie_repository.dart';
import 'genre_fetcher_cubit.dart';

part 'movies_now_showing_state.dart';

class MoviesNowShowingCubit extends Cubit<MoviesNowShowingState> {
  bool isLoading = false;
  bool isAllResultsLoaded = false;
  int pageNumber = 1;
  List<int> listOfAllMoviesId = [];

  final GenreFetcherCubit genreFetcherCubit;
  StreamSubscription _genreFetcherCubitSubscription;

  // CancelableOperation beginLoadingHandler;
  CancelableOperation loadMoreResultsHandler;
  int timeoutSeconds = 10;

  Connectivity _connectivity = Connectivity();
  StreamSubscription _connectivitySubscription;

  DataConnectionChecker _dataConnectionChecker = DataConnectionChecker()
    ..checkInterval = Duration(seconds: 1);
  StreamSubscription _dataSubscription;

  MoviesNowShowingCubit({
    @required this.genreFetcherCubit,
  }) : super(MoviesNowShowingLoading()) {
    // print("Emitting: MoviesNowShowingLoading");
    /*
    Use the following only in case when jub internet wapas aaye 
    after loading failed initially, because Connectivity() 
    doesn't always return current state
    */
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (_connectivityResult) {
        // print(
        //     "ConnectivityResult @ MoviesNowShowingCubit: $_connectivityResult");
        if (_connectivityResult != ConnectivityResult.none) {
          if (state is MoviesNowShowingFailed) {
            if (genreFetcherCubit.state is GenreFetcherLoaded) {
              _dataSubscription = _dataConnectionChecker.onStatusChange.listen(
                (_dataConnectionStatus) {
                  if (_dataConnectionStatus == DataConnectionStatus.connected) {
                    // print(
                    //     "Starting MoviesNowShowingCubit Loading results since Genre Already Loaded");
                    loadResults();
                    _dataSubscription.cancel();
                  }
                },
              );
            }
          }
        }
      },
    );

    _genreFetcherCubitSubscription = genreFetcherCubit.listen((state) {
      // print('GenreFetcherState: $state');
      if (state is GenreFetcherLoaded) {
        loadResults();
        _genreFetcherCubitSubscription
            .cancel(); //   // genreFetcherCubit.startFetching();
      } else if (state is GenreFetcherLoading) {
        emit(MoviesNowShowingLoading());
      } else {
        emit(MoviesNowShowingFailed());
      }
    });
    // beginLoading();
    // loadResults();
  }

  // List<int> addListAndReturn(List<int> inputList) {
  //   listOfAllMoviesId = listOfAllMoviesId + inputList;
  //   return listOfAllMoviesId.toSet().toList();
  // }

  void updateList(List<int> inputList) {
    listOfAllMoviesId = listOfAllMoviesId + inputList;
  }

  // Future<void> beginLoading({bool isForced = false}) async {
  //   if (!isLoading || isForced) {
  //     beginLoadingHandler?.cancel();
  //     beginLoadingHandler = CancelableOperation.fromFuture(
  //       loadResults(),
  //       onCancel: () => print("beginLoadingFunction Cancelled"),
  //     );
  //   }
  // }

  // Future<void> loadResults({bool isForced = false}) async {
  //   if ((!isLoading && !isAllResultsLoaded) || isForced) {
  //     loadMoreResultsHandler?.cancel();
  //     loadMoreResultsHandler = CancelableOperation.fromFuture(
  //       _loadResultsFunction(),
  //       onCancel: () => print("loadMoreResultsFunction Cancelled"),
  //     );
  //   }
  // }

  Future<void> loadResults({bool isForced = false}) async {
    if ((!isLoading && !isAllResultsLoaded) || isForced) {
      emitLoadingState();
      isLoading = true;
      loadMoreResultsHandler?.cancel();
      loadMoreResultsHandler = CancelableOperation.fromFuture(
        MovieRepository().getMoviesFromServer(
          queryType: GetMovies.nowPlaying,
          pageNumber: pageNumber.toString(),
        ),
        onCancel: () {
          // print("loadMoreResultsFunction Cancelled");
        },
      );

      loadMoreResultsHandler.value.then((value) {
        List<int> _listOfMovieIds = value as List<int>;
        if (_listOfMovieIds.isEmpty) {
          emit(MoviesNowShowingLoaded(isAllLoaded: true));
          isAllResultsLoaded = true;
          _connectivitySubscription?.cancel();
        } else {
          updateList(_listOfMovieIds);
          emit(MoviesNowShowingLoaded());
          pageNumber++;
        }
      }).catchError((_) {
        emit(MoviesNowShowingFailed());
      }).then((_) {
        isLoading = false;
      });
    }
  }

  Future<void> emitLoadingState() async {
    // if (state is! MoviesNowShowingLoading) {
    emit(MoviesNowShowingLoading());
    // }
    await Future.delayed(Duration(seconds: timeoutSeconds));
    if (state is MoviesNowShowingLoading) {
      emit(MoviesNowShowingLoading(timeoutExhausted: true));
    }
  }

  void reloadResult() async {
    loadResults(isForced: true);
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _genreFetcherCubitSubscription?.cancel();
    _dataSubscription?.cancel();
    return super.close();
  }
}
