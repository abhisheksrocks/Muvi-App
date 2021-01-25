// 🎯 Dart imports:
import 'dart:async';

// 📦 Package imports:
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:meta/meta.dart';

// 🌎 Project imports:
import '../common/all_enums.dart';
import '../models/image_bucket.dart';

part 'image_manager_state.dart';

class ImageManagerCubit extends Cubit<ImageManagerState> {
  final String posterImagePath;
  final double placeholderWidth;

  Connectivity _connectivity = Connectivity();
  StreamSubscription _connectivitySubscription;

  DataConnectionChecker _dataConnectionChecker = DataConnectionChecker()
    ..checkInterval = Duration(seconds: 1);
  StreamSubscription _dataSubscription;
  // final PosterSizes preferredPlaceholderSize;
  // final PosterSizes preferredImageSize;
  ImageManagerCubit({
    @required this.posterImagePath,
    this.placeholderWidth = 100,
    // this.preferredImageSize,
    // this.preferredPlaceholderSize,
  }) : super(ImageManagerLoading()) {
    // if (preferredPlaceholderSize != null) {
    //   _placeholderUrl =
    //       "https://image.tmdb.org/t/p/${EnumToString.convertToString(preferredPlaceholderSize)}$posterImagePath";
    // }
    // if (preferredImageSize != null) {
    //   _imageUrl =
    //       "https://image.tmdb.org/t/p/${EnumToString.convertToString(preferredImageSize)}$posterImagePath";
    // }
    // emit(ImageManagerLoading());

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((_connectivityResult) {
      // print("ConnectivityResult @ GenreFetcherCubit: $_connectivityResult");
      if (_connectivityResult != ConnectivityResult.none) {
        var widgetState = state;
        if (widgetState is ImageManagerFailed) {
          if (!widgetState.isImagepathEmpty) {
            _dataSubscription = _dataConnectionChecker.onStatusChange.listen(
              (_dataConnectionStatus) {
                if (_dataConnectionStatus == DataConnectionStatus.connected) {
                  // print("Starting GenreFetcherCubit");
                  emit(ImageManagerLoaded());
                  _dataSubscription.cancel();
                }
              },
            );
          } else {
            _connectivitySubscription.cancel();
          }
        }
      }
    });

    // print("Managing for $posterImagePath");
    if (posterImagePath == null || posterImagePath?.trim() == '') {
      emit(ImageManagerFailed(
        isImagepathEmpty: true,
      ));
    } else {
      var a = _imageBucket.getImageUrl(imagePath: posterImagePath);
      if (a != null) {
        if (findWidthForImage(a) >= placeholderWidth) {
          imageUrl = a;
          // print("Already found");
          emit(ImageManagerLoaded());
        } else {
          placeholderUrl = a;
          // print("Just placeholder found");
          emit(ImageManagerLoading());
          findAndGetImage();
        }
      } else {
        findAndGetImage();
      }
    }
  }

  void emitNetworkFailState() {
    emit(ImageManagerFailed(isImagepathEmpty: false));
  }

  int findWidthForImage(String url) {
    try {
      int width = int.parse(url.substring(28, 31));
      return width;
    } catch (_) {
      return null;
    }
  }

  String placeholderUrl;
  String imageUrl;

  ImageBucket _imageBucket = ImageBucket();

  // List<String> _urlToShow = [];

  CacheManager _cacheManager = DefaultCacheManager();

  bool operator >=(double width) {
    return true;
  }

  void findAndGetImage() async {
    for (int index = PosterSizes.values.length - 1; index >= 0; index--) {
      PosterSizes _currentSize = PosterSizes.values.elementAt(index);
      FileInfo _fileInfo = await _cacheManager.getFileFromCache(
        "https://image.tmdb.org/t/p/${EnumToString.convertToString(_currentSize)}$posterImagePath",
      );
      if (_fileInfo != null) {
        if (int.parse(
                EnumToString.convertToString(_currentSize).substring(1)) >=
            placeholderWidth) {
          imageUrl ??= _fileInfo.originalUrl;
          emit(ImageManagerLoaded());
          // print("found ImageUrl: $imageUrl");
          _imageBucket.setImageUrl(
            imagePath: posterImagePath,
            imageSize: _currentSize,
          );
        } else {
          placeholderUrl ??= _fileInfo.originalUrl;
          // print("found placeholderUrl: $placeholderUrl");
          // _urlToShow.add(_fileInfo.originalUrl);
          emit(ImageManagerLoading());
        }
        break;
      }
    }

    if (imageUrl == null) {
      // print("Couldn't find cache for $posterImagePath");
      // print("Finding required result then");
      // if (_urlToShow.isEmpty) {
      //   findAdequateImage();
      //   emit(ImageManagerLoaded());
      // } else {
      //   _placeholderUrl ??= _urlToShow.last;
      //   findAdequateImage();
      //   emit(ImageManagerLoaded());
      // }
      findAdequateImage();
      emit(ImageManagerLoaded());
    }
  }

  void findAdequateImage() {
    PosterSizes _posterSize;
    if (placeholderWidth < 92) {
      _posterSize = PosterSizes.w92;
    } else if (placeholderWidth < 154) {
      _posterSize = PosterSizes.w154;
    } else if (placeholderWidth < 185) {
      _posterSize = PosterSizes.w185;
    } else if (placeholderWidth < 342) {
      _posterSize = PosterSizes.w342;
    } else if (placeholderWidth < 500) {
      _posterSize = PosterSizes.w500;
    } else if (placeholderWidth < 780) {
      _posterSize = PosterSizes.w780;
    } else {
      _posterSize = PosterSizes.original;
    }
    imageUrl ??=
        ("https://image.tmdb.org/t/p/${EnumToString.convertToString(_posterSize)}$posterImagePath");
    // print("ImageUrl: $imageUrl");
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _dataSubscription?.cancel();
    return super.close();
  }
}
