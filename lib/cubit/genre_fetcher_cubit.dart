// 🎯 Dart imports:
import 'dart:async';

// 📦 Package imports:
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';

// 🌎 Project imports:
import '../repositories/genre_repository.dart';

part 'genre_fetcher_state.dart';

class GenreFetcherCubit extends Cubit<GenreFetcherState> {
  Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;

  InternetConnectionChecker _dataConnectionChecker = InternetConnectionChecker()
    ..checkInterval = Duration(seconds: 1);
  StreamSubscription? _dataSubscription;

  GenreFetcherCubit() : super(GenreFetcherLoading()) {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((_connectivityResult) {
      if (_connectivityResult != ConnectivityResult.none) {
        if (state is GenreFetcherFailed) {
          _dataSubscription = _dataConnectionChecker.onStatusChange.listen(
            (_dataConnectionStatus) {
              if (_dataConnectionStatus == InternetConnectionStatus.connected) {
                startFetching();
                _dataSubscription?.cancel();
              }
            },
          );
        }
      }

      if (state is GenreFetcherLoaded) {
        _connectivitySubscription?.cancel();
      }
    });
    startFetching();
  }

  void startFetching() async {
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
