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

part 'movie_certification_state.dart';

class MovieCertificationCubit extends Cubit<MovieCertificationState> {
  final int movieId;
  int timeoutSeconds = 10;

  Connectivity _connectivity = Connectivity();
  StreamSubscription _connectivitySubscription;

  DataConnectionChecker _dataConnectionChecker = DataConnectionChecker()
    ..checkInterval = Duration(seconds: 1);
  StreamSubscription _dataSubscription;

  CancelableOperation getCertificationHandler;

  MovieCertificationCubit({
    @required this.movieId,
  }) : super(MovieCertificationLoading()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (_connectivityResult) {
        print(
            "ConnectivityResult @ MovieCertificationCubit: $_connectivityResult");
        if (_connectivityResult != ConnectivityResult.none) {
          if (state is MovieCertificationFailed) {
            _dataSubscription = _dataConnectionChecker.onStatusChange.listen(
              (_dataConnectionStatus) {
                if (_dataConnectionStatus == DataConnectionStatus.connected) {
                  print("Starting MovieCertificationCubit Loading");
                  getCertificationInfo();
                  _dataSubscription.cancel();
                }
              },
            );
          }
        }
      },
    );

    // startFetching();

    getCertificationInfo();
  }

  void research() {
    // startFetching();
    getCertificationInfo();
  }

  void getCertificationInfo() {
    emitLoadingState();
    String _certification = MovieBucket().getInfo(movieId).certification;
    if (_certification == null || _certification.isEmpty) {
      // print("Cast details not present");
      getCertificationHandler?.cancel();
      getCertificationHandler = CancelableOperation.fromFuture(
        MovieRepository().getCertification(movieId: movieId),
        onCancel: () {
          // print('gettingCastInfoHandler cancelled');
        },
      );

      getCertificationHandler.value.then((value) {
        String result = value as String;
        emit(MovieCertificationLoaded(certificate: result));
      }).catchError((_) {
        emit(MovieCertificationFailed());
      });
    } else {
      // print("Cast details is present");
      emit(
        MovieCertificationLoaded(
          certificate: _certification,
        ),
      );
    }
  }

  // void startFetching() async {
  //   emit(MovieCertificationLoading());
  //   try {
  //     List<String> _listOfCasts = MovieBucket().getInfo(movieId).casts;
  //     if (_listOfCasts == null || _listOfCasts.isEmpty) {
  //       // print("Cast details not present");
  //       emit(
  //         MovieCertificationLoaded(
  //           listOfCasts: await MovieRepository().getCastInfo(movieId: movieId),
  //         ),
  //       );
  //     } else {
  //       // print("Cast details is present");
  //       emit(
  //         MovieCertificationLoaded(
  //           listOfCasts: _listOfCasts,
  //         ),
  //       );
  //     }
  //   } catch (_) {
  //     emit(MovieCertificationFailed());
  //   }
  // }

  Future<void> emitLoadingState() async {
    emit(MovieCertificationLoading());
    await Future.delayed(Duration(seconds: timeoutSeconds));
    if (state is MovieCertificationLoading) {
      emit(MovieCertificationLoading(timeoutExhausted: true));
    }
  }

  @override
  Future<void> close() {
    getCertificationHandler?.cancel();
    _connectivitySubscription?.cancel();
    _dataSubscription?.cancel();
    return super.close();
  }
}
