// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:http/http.dart' as http;

// 🌎 Project imports:
import '../common/api_credentials.dart';
import '../models/genre_bucket.dart';

class GenreRepository {
  final String _apiKey = ApiCredentials().apiKey;
  final GenreBucket _genresBucket = GenreBucket();

  Future<void> fetchGenres(
      // {
      // String
      //     language, //TBH right now language option isn't useful at all, don't use it
      // }
      ) async {
    // print("Came here");
    String _query =
        "https://api.themoviedb.org/3/genre/movie/list?api_key=$_apiKey";
    // if (language != null) {
    //   _query = "$_query&language=$language";
    // }
    // http.get(Uri.parse(uri))
    Uri uri = Uri.parse(_query);
    print("URI : $uri");
    Uri newUri =
        Uri.http("api.themoviedb.org", "/3/genre/movie/list?api_key=$_apiKey");
    print("newURI : $newUri");
    final http.Response _response = await http.get(newUri);
    print("Response.statuscode: ${_response.statusCode}");
    switch (_response.statusCode) {
      case 200:
        final List result =
            (jsonDecode(_response.body) as Map<String, dynamic>)['genres'];
        result.forEach((element) {
          _genresBucket.addGenre(
            id: element['id'],
            genre: element['name'],
          );
        });
        return;
      default:
        // print("Response Status Code: ${_response.statusCode}");
        // print(
        //     "Status Message: ${(jsonDecode(_response.body) as Map<String, dynamic>)['status_message']}");
        throw Exception();
    }
  }
}
