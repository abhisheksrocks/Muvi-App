// 📦 Package imports:
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// 🌎 Project imports:
import '../common/all_enums.dart';

class ImageBucket {
  static Map<String, Map<String, int>> _imageBucket = Map();

  static ImageBucket _instance;

  factory ImageBucket() {
    if (_instance == null) {
      _instance = ImageBucket._();
    }
    // print("_imageBucket: $_imageBucket");
    return _instance;
  }

  ImageBucket._();

  String getImageUrl({String imagePath}) {
    // return _imageBucket['$imagePath'] != null
    //     ? _imageBucket['$imagePath']['imageUrl']
    //     : null;
    if (_imageBucket['$imagePath'] != null) {
      return "https://image.tmdb.org/t/p/w${_imageBucket['$imagePath']['imageUrl']}$imagePath";
    }
    return null;
  }

  // String getPlaceholderUrl({String imagePath}) {
  //   return _imageBucket['$imagePath']['placeholderUrl'];
  // }

  void setImageUrl({String imagePath, PosterSizes imageSize}) {
    int sizeOfImageToInsert =
        int.parse(EnumToString.convertToString(imageSize).substring(1));
    // var a = _imageBucket['$imagePath'];
    // if (a == null) {
    //   a = Map();
    // }
    // a['imageUrl'] = imageUrl;
    // if (_imageBucket['$imagePath'] == null) {
    _imageBucket['$imagePath'] ??= Map();
    // }

    // _imageBucket['$_imageBucket'] ??= Map();
    // _imageBucket['$_imageBucket']['imageUrl'] = imageUrl;
    if (_imageBucket['$imagePath']['imageUrl'] != null) {
      int sizeOfImageThatAlreadyExists = _imageBucket['$imagePath']['imageUrl'];
      if (sizeOfImageThatAlreadyExists < sizeOfImageToInsert) {
        DefaultCacheManager().removeFile(
            "https://image.tmdb.org/t/p/w${_imageBucket['$imagePath']['imageUrl']}$imagePath");
        _imageBucket['$imagePath']['imageUrl'] = sizeOfImageToInsert;
      }
      // else{
      // }
    } else {
      _imageBucket['$imagePath']['imageUrl'] = sizeOfImageToInsert;
    }
  }

  // void setPlaceholderUrl({String imagePath, String placeholderUrl}) {
  //   _imageBucket['$imagePath']['placeholderUrl'] = placeholderUrl;
  // }
}
