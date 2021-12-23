// 🎯 Dart imports:
import 'dart:async';

// 📦 Package imports:
import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';

// 🌎 Project imports:
import '../common/all_enums.dart';
import '../repositories/movie_repository.dart';
import 'genre_fetcher_cubit.dart';

part 'movies_popular_state.dart';

class MoviesPopularCubit extends Cubit<MoviesPopularState> {
  bool isLoading = false;
  bool isAllResultsLoaded = false;
  int pageNumber = 1;
  List<int> listOfAllMoviesId = [];
  final GenreFetcherCubit genreFetcherCubit;
  StreamSubscription? _genreFetcherCubitSubscription;

  // CancelableOperation? beginLoadingHandler;
  CancelableOperation? loadMoreResultsHandler;
  int timeoutSeconds = 10;

  Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;

  InternetConnectionChecker _dataConnectionChecker = InternetConnectionChecker()
    ..checkInterval = Duration(seconds: 1);
  StreamSubscription? _dataSubscription;

  MoviesPopularCubit({
    required this.genreFetcherCubit,
  }) : super(MoviesPopularLoading()) {
    // print("Emitting: MoviesPopularLoading");
    /*
    Use the following only in case when jub internet wapas aaye 
    after loading failed initially, because Connectivity() 
    doesn't always return current state
    */
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (_connectivityResult) {
        // print("ConnectivityResult @ MoviesPopularCubit: $_connectivityResult");
        if (_connectivityResult != ConnectivityResult.none) {
          if (state is MoviesPopularFailed) {
            if (genreFetcherCubit.state is GenreFetcherLoaded) {
              _dataSubscription = _dataConnectionChecker.onStatusChange.listen(
                (_dataConnectionStatus) {
                  if (_dataConnectionStatus ==
                      InternetConnectionStatus.connected) {
                    // print(
                    //     "Starting MoviesPopularCubit Loading results since Genre Already Loaded");
                    loadResults();
                    _dataSubscription?.cancel();
                  }
                },
              );
            }
          }
        }
      },
    );

    _genreFetcherCubitSubscription = genreFetcherCubit.stream.listen((state) {
      // print('GenreFetcherState: $state');
      if (state is GenreFetcherLoaded) {
        loadResults();
        _genreFetcherCubitSubscription!
            .cancel(); //   // genreFetcherCubit.startFetching();
      } else if (state is GenreFetcherLoading) {
        emit(MoviesPopularLoading());
      } else {
        emit(MoviesPopularFailed());
      }
    });
  }

  List<int> addListAndReturn(List<int> inputList) {
    listOfAllMoviesId = listOfAllMoviesId + inputList;
    return listOfAllMoviesId.toSet().toList();
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
        MovieRepository().getMoviesFromServer(
          queryType: GetMovies.popular,
          pageNumber: pageNumber.toString(),
        ),
        onCancel: () {
          // print("loadMoreResultsFunction Cancelled");
        },
      );

      loadMoreResultsHandler?.value.then((value) {
        List<int> _listOfMovieIds = value as List<int>;
        if (_listOfMovieIds.isEmpty) {
          emit(MoviesPopularLoaded(isAllLoaded: true));
          isAllResultsLoaded = true;
          _connectivitySubscription?.cancel();
        } else {
          updateList(_listOfMovieIds);
          emit(MoviesPopularLoaded());
          pageNumber++;
        }
      }).catchError((_) {
        emit(MoviesPopularFailed());
      }).then((_) {
        isLoading = false;
      });
    }
  }

  Future<void> emitLoadingState() async {
    emit(MoviesPopularLoading());
    await Future.delayed(Duration(seconds: timeoutSeconds));
    if (state is MoviesPopularLoading) {
      emit(MoviesPopularLoading(timeoutExhausted: true));
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
    loadMoreResultsHandler?.cancel();
    return super.close();
  }
}
