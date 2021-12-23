// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';

// 📦 Package imports:
import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';

// 🌎 Project imports:
import '../repositories/movie_repository.dart';

part 'movies_search_state.dart';

class MoviesSearchCubit extends Cubit<MoviesSearchState> {
  List<int> listOfAllMoviesId = [];
  String lastQuery = '';
  int _pageNumber = 1;
  bool _isLoading = false;
  bool isAllResultsLoaded = false;
  int timeoutSeconds = 10;

  Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;

  InternetConnectionChecker _dataConnectionChecker = InternetConnectionChecker()
    ..checkInterval = Duration(seconds: 1);
  StreamSubscription? _dataSubscription;

  CancelableOperation? searchDelayHandler;
  CancelableOperation? searchForMovieHandler;
  CancelableOperation? loadingStateHandler; //required just for this

  MoviesSearchCubit() : super(MoviesSearchEmptyQuery()) {
    // print("MovieSearchCubit stated with state: $state");

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((_connectivityResult) {
      // print("ConnectivityResult @ MoviesSearchCubit: $_connectivityResult");
      if (_connectivityResult != ConnectivityResult.none) {
        if (state is MoviesSearchFailed) {
          _dataSubscription = _dataConnectionChecker.onStatusChange.listen(
            (_dataConnectionStatus) {
              if (_dataConnectionStatus == InternetConnectionStatus.connected) {
                // print("Starting MoviesSearchCubit");
                research();
                _dataSubscription?.cancel();
              }
            },
          );
        }
      }
    });
  }

  void updateList(List<int> inputList) {
    listOfAllMoviesId = listOfAllMoviesId + inputList;
  }

  void research() {
    searchForMovie(searchQuery: lastQuery, isForced: true);
  }

  void searchForMovie({
    required String searchQuery,
    bool isForced = false,
    bool fromDrag = false,
  }) {
    searchQuery = searchQuery.trim();
    // print("searchQuery : $searchQuery");
    // print("lastQuery : $lastQuery");
    // print("fromDrag: $fromDrag");
    // print("isNOT loading: ${!_isLoading}");
    if (searchQuery != lastQuery || (fromDrag && !_isLoading) || (isForced)) {
      // print("Entered");
      if (searchQuery.isNotEmpty) {
        searchDelayHandler?.cancel();
        searchForMovieHandler?.cancel();
        loadingStateHandler?.cancel();
        searchDelayHandler = CancelableOperation.fromFuture(
          (fromDrag || isForced)
              ? Future.value()
              : Future.delayed(Duration(seconds: 1)),
          onCancel: () {
            if (!isForced) {
              lastQuery = searchQuery;
              listOfAllMoviesId = [];
              if (fromDrag) {
                _pageNumber = 1;
              }
            }

            // print('searchDelayHandler cancelled');
          },
        );
        searchDelayHandler?.value.whenComplete(() {
          // fromDrag
          //     ? print("Called Immediately with searchQuery: $searchQuery")
          //     : print("Called after 2 seconds with searchQuery: $searchQuery");
          if (searchQuery != lastQuery) {
            listOfAllMoviesId = [];
          }
          lastQuery = searchQuery;
          // await searchForMovieFunction(
          //   pageNumber: fromDrag ? _pageNumber : 1,
          //   searchQuery: searchQuery,
          // );
          _isLoading = true;
          // print("Loading called when query: $searchQuery");
          // emit(MoviesSearchLoading());
          loadingStateHandler?.cancel();
          loadingStateHandler = CancelableOperation.fromFuture(
            emitLoadingState(),
            onCancel: () => print("Loading state resetted"),
          );
          loadingStateHandler?.value.whenComplete(() {
            if (state is MoviesSearchLoading) {
              emit(MoviesSearchLoading(timeoutExhausted: true));
            }
          });
          if (!fromDrag) {
            _pageNumber = 1;
          }
          // print("pageNumber: ${fromDrag ? _pageNumber : 1}");
          searchForMovieHandler?.cancel();
          searchForMovieHandler = CancelableOperation.fromFuture(
            MovieRepository().searchMovie(
              searchQuery: searchQuery,
              page: _pageNumber,
            ),
            onCancel: () {
              // print('searchForMovieHandler Cancelled');
            },
          );

          searchForMovieHandler?.value.then((value) {
            List<int> _listToReturn = value as List<int>;
            if (_listToReturn.isNotEmpty) {
              updateList(_listToReturn);
              _pageNumber++;
              // print("Loaded called when query: $searchQuery");
              emit(MoviesSearchLoaded());
            } else {
              // print("Loaded called when query: $searchQuery");
              emit(MoviesSearchLoaded(isAllLoaded: true));
            }
          }).catchError((_) {
            // print("While searching caught an error");
            emit(MoviesSearchFailed());
          }).then((_) {
            _isLoading = false;
          });
        });
      } else {
        searchDelayHandler?.cancel();
        searchForMovieHandler?.cancel();
        loadingStateHandler?.cancel();
        _isLoading = false;
        if (listOfAllMoviesId.length == 0) {
          //1
          emit(MoviesSearchEmptyQuery()); //1
        } //1
        lastQuery = '';
        // listOfAllMoviesId = [];
        _pageNumber = 1;
      }
    }
    // else {
    // print("Couldn't enter");
    // }
  }

  Future<void> emitLoadingState() async {
    emit(MoviesSearchLoading());
    await Future.delayed(Duration(seconds: timeoutSeconds));
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _dataSubscription?.cancel();
    searchDelayHandler?.cancel();
    searchForMovieHandler?.cancel();
    return super.close();
  }
}
