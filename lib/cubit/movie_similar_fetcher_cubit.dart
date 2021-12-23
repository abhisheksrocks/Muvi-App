// 🎯 Dart imports:
import 'dart:async';

// 📦 Package imports:
import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';

// 🌎 Project imports:
import '../repositories/movie_repository.dart';

part 'movie_similar_fetcher_state.dart';

class MoviesSimilarFetcherCubit extends Cubit<MoviesSimilarFetcherState> {
  bool isLoading = false;
  bool isAllResultsLoaded = false;
  int pageNumber = 1;
  List<int> listOfAllMoviesId = [];
  final int movieId;

  // CancelableOperation? beginLoadingHandler;
  CancelableOperation? loadMoreResultsHandler;
  int timeoutSeconds = 10;

  Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;

  InternetConnectionChecker _dataConnectionChecker = InternetConnectionChecker()
    ..checkInterval = Duration(seconds: 1);
  StreamSubscription? _dataSubscription;

  MoviesSimilarFetcherCubit({required this.movieId})
      : super(MoviesSimilarFetcherLoading()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (_connectivityResult) {
        // print(
        //     "ConnectivityResult @ MoviesSimilarFetcherCubit: $_connectivityResult");
        if (_connectivityResult != ConnectivityResult.none) {
          if (state is MoviesSimilarFetcherFailed) {
            _dataSubscription = _dataConnectionChecker.onStatusChange.listen(
              (_dataConnectionStatus) {
                if (_dataConnectionStatus ==
                    InternetConnectionStatus.connected) {
                  // print("Starting MoviesSimilarFetcherCubit Loading");
                  loadResults();
                  _dataSubscription?.cancel();
                }
              },
            );
          }
        }
      },
    );
    loadResults();
  }

  void updateList(List<int> inputList) {
    listOfAllMoviesId = listOfAllMoviesId + inputList;
  }

  Future<void> loadResults({bool isForced = false}) async {
    if ((!isLoading && !isAllResultsLoaded) || isForced) {
      emitLoadingState();
      isLoading = true;
      loadMoreResultsHandler?.cancel();
      loadMoreResultsHandler = CancelableOperation.fromFuture(
        MovieRepository().getSimilarMovies(
          movieId: movieId,
          page: pageNumber,
        ),
        onCancel: () {
          // print("loadMoreResultsFunction Cancelled");
        },
      );

      loadMoreResultsHandler?.value.then((value) {
        List<int> _listOfMovieIds = value as List<int>;
        if (_listOfMovieIds.isEmpty) {
          emit(MoviesSimilarFetcherLoaded(isAllLoaded: true));
          isAllResultsLoaded = true;
          _connectivitySubscription?.cancel();
        } else {
          updateList(_listOfMovieIds);
          emit(MoviesSimilarFetcherLoaded());
          pageNumber++;
        }
      }).catchError((_) {
        emit(MoviesSimilarFetcherFailed());
      }).then((_) {
        isLoading = false;
      });
    }
  }

  Future<void> emitLoadingState() async {
    emit(MoviesSimilarFetcherLoading());
    await Future.delayed(Duration(seconds: timeoutSeconds));
    if (state is MoviesSimilarFetcherLoading) {
      emit(MoviesSimilarFetcherLoading(timeoutExhausted: true));
    }
  }

  void reloadResult() {
    loadResults(isForced: true);
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _dataSubscription?.cancel();
    return super.close();
  }
}
