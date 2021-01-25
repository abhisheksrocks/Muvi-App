// 🎯 Dart imports:
import 'dart:async';

// 📦 Package imports:
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
// import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

// 🌎 Project imports:
import '../repositories/genre_repository.dart';

part 'genre_fetcher_state.dart';

class GenreFetcherCubit extends Cubit<GenreFetcherState> {
  // Logger _logger = Logger();
  Connectivity _connectivity = Connectivity();
  StreamSubscription _connectivitySubscription;

  DataConnectionChecker _dataConnectionChecker = DataConnectionChecker()
    ..checkInterval = Duration(seconds: 1);
  StreamSubscription _dataSubscription;

  GenreFetcherCubit() : super(GenreFetcherLoading()) {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((_connectivityResult) {
      // print("ConnectivityResult @ GenreFetcherCubit: $_connectivityResult");
      if (_connectivityResult != ConnectivityResult.none) {
        if (state is GenreFetcherFailed) {
          _dataSubscription = _dataConnectionChecker.onStatusChange.listen(
            (_dataConnectionStatus) {
              if (_dataConnectionStatus == DataConnectionStatus.connected) {
                // print("Starting GenreFetcherCubit");

                startFetching();
                _dataSubscription.cancel();
              }
            },
          );
        }
      }

      if (state is GenreFetcherLoaded) {
        _connectivitySubscription.cancel();
      }
    });
    startFetching();
  }

  void startFetching() async {
    // _logger.d("Begging to Fetch Genres");
    emit(GenreFetcherLoading());
    try {
      await GenreRepository().fetchGenres();
      emit(GenreFetcherLoaded());
    } catch (_) {
      emit(GenreFetcherFailed());
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _dataSubscription?.cancel();
    return super.close();
  }
}
