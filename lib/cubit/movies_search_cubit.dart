// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';

// 📦 Package imports:
import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
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
  StreamSubscription _connectivitySubscription;

  DataConnectionChecker _dataConnectionChecker = DataConnectionChecker()
    ..checkInterval = Duration(seconds: 1);
  StreamSubscription _dataSubscription;

  // CancelableCompleter searchForMovieHandler;
  CancelableOperation searchDelayHandler;
  CancelableOperation searchForMovieHandler;
  CancelableOperation loadingStateHandler; //required just for this
  // CancelableOperation loadMoreResultsHandler;

  MoviesSearchCubit() : super(MoviesSearchEmptyQuery()) {
    // print("MovieSearchCubit stated with state: $state");

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((_connectivityResult) {
      // print("ConnectivityResult @ MoviesSearchCubit: $_connectivityResult");
      if (_connectivityResult != ConnectivityResult.none) {
        if (state is MoviesSearchFailed) {
          _dataSubscription = _dataConnectionChecker.onStatusChange.listen(
            (_dataConnectionStatus) {
              if (_dataConnectionStatus == DataConnectionStatus.connected) {
                // print("Starting MoviesSearchCubit");
                research();
                _dataSubscription.cancel();
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
    @required String searchQuery,
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
        searchDelayHandler.value.whenComplete(() {
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
          loadingStateHandler.value.whenComplete(() {
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

          searchForMovieHandler.value.then((value) {
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
    } else {
      // print("Couldn't enter");
    }
  }

  Future<void> emitLoadingState() async {
    emit(MoviesSearchLoading());
    await Future.delayed(Duration(seconds: timeoutSeconds));
  }

  // Future<void> searchForMovieFunction({
  //   int pageNumber = 1,
  //   @required String searchQuery,
  // }) async {
  //   _isLoading = true;
  //   emit(MoviesSearchLoading());
  //   print("pageNumber: $pageNumber");
  //   try {
  //     List<int> _listToReturn = await MovieRepository().searchMovie(
  //       searchQuery: searchQuery,
  //       page: pageNumber,
  //     );
  //     if (_listToReturn.isNotEmpty) {
  //       updateList(_listToReturn);
  //       _pageNumber++;
  //       emit(MoviesSearchLoaded());
  //     } else {
  //       emit(MoviesSearchLoaded(isAllLoaded: true));
  //     }
  //     // return _listToReturn;
  //   } catch (_) {
  //     emit(MoviesSearchFailed());
  //   } finally {
  //     _isLoading = false;
  //   }
  // }

  // void searchForMovie({
  //   @required String searchQuery,
  //   bool isForced = false,
  //   bool fromDrag = false,
  // }) {
  //   print("SearchQuery: $searchQuery");
  //   print("From Drag: $fromDrag");
  //   // if () {
  //   if ((searchQuery != lastQuery || fromDrag) && !_isLoading) {
  //     print(
  //         "searchQuery != lastQuery, with searchQuery: $searchQuery and lastQuery: $lastQuery => ${searchQuery != lastQuery}");
  //     print("!_isLoading : ${!_isLoading}");
  //     print("searchQuery.isNotEmpty : ${searchQuery.isNotEmpty}");

  //     // searchForMovieHandler?.cancel();
  //     // searchForMovieHandler?.operation?.cancel();
  //     // searchForMovieHandler = CancelableOperation.fromFuture(
  //     //   searchForMovieFunction(
  //     //     searchQuery: searchQuery,
  //     //     isForced: isForced,
  //     //     fromDrag: fromDrag,
  //     //   ),
  //     //   onCancel: () => print('searchForMovieFunction Cancelled'),
  //     // );
  //     // searchForMovieHandler = CancelableCompleter(
  //     //   onCancel: () => print('searchForMovieFunction Cancelled'),
  //     // );
  //     // searchForMovieHandler.complete(
  //     //   searchForMovieFunction(
  //     //     searchQuery: searchQuery,
  //     //     isForced: isForced,
  //     //     fromDrag: fromDrag,
  //     //   ),
  //     // );
  //   }
  //   // }
  // }

  // Future<void> loadMoreResult({bool isForced}) async {
  //   if (_lastQuery.isNotEmpty && state is MoviesSearchLoaded && !_isLoading) {
  //     emit(MoviesSearchLoading());
  //     try {
  //       List<int> _listOfMoviesId =
  //           await MovieRepository().searchMovie(searchQuery: _lastQuery);
  //     } catch (_) {
  //       emit(MoviesSearchFailed());
  //     }
  //   }
  // }

  // Future<void> _loadResultsFunction() async {
  //   isLoading = true;
  //   emit(MoviesUpcomingLoading());
  //   try {
  //     List<int> _listOfMovieIds = await MovieRepository().getMoviesFromServer(
  //       queryType: GetMovies.upcoming,
  //       pageNumber: pageNumber.toString(),
  //     );
  //     if (_listOfMovieIds.isEmpty) {
  //       emit(MoviesUpcomingLoaded(isAllLoaded: true));
  //       isAllResultsLoaded = true;
  //       _connectivitySubscription?.cancel();
  //     } else {
  //       updateList(_listOfMovieIds);
  //       emit(MoviesUpcomingLoaded());
  //       pageNumber++;
  //     }
  //   } catch (_) {
  //     emit(MoviesUpcomingFailed());
  //   }
  //   isLoading = false;
  // }

  // Future<void> searchForMovieFunction({
  //   @required String searchQuery,
  //   @required bool isForced,
  //   @required bool fromDrag,
  // }) async {
  //   if (searchQuery.isNotEmpty) {
  //     _isLoading = true;
  //     if (!fromDrag) {
  //       await Future.delayed(Duration(seconds: 2));
  //       pageNumber = 1;
  //       listOfAllMoviesId = [];
  //     }
  //     emit(MoviesSearchLoading());
  //     try {
  //       List<int> _listOfMoviesId = await MovieRepository().searchMovie(
  //         searchQuery: searchQuery,
  //         page: pageNumber,
  //       );
  //       updateList(_listOfMoviesId);
  //       if (_listOfMoviesId.isEmpty) {
  //         isAllResultsLoaded = true;
  //         emit(MoviesSearchLoaded(isAllLoaded: true));
  //       } else {
  //         emit(MoviesSearchLoaded());
  //         pageNumber++;
  //       }
  //       print("Finishing");
  //     } catch (error) {
  //       print("error occured");
  //       print(error);
  //       emit(MoviesSearchFailed());
  //     } finally {
  //       _isLoading = false;
  //       lastQuery = searchQuery;
  //       print("updating lastQuery: $lastQuery");
  //     }
  //   } else {
  //     lastQuery = '';
  //     emit(MoviesSearchEmptyQuery());
  //   }
  // }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _dataSubscription?.cancel();
    searchDelayHandler?.cancel();
    searchForMovieHandler?.cancel();
    return super.close();
  }
}
