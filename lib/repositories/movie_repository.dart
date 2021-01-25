// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

// 🌎 Project imports:
import '../common/all_enums.dart';
import '../common/api_credentials.dart';
import '../models/cast_bucket.dart';
import '../models/movie_bucket.dart';
import '../models/person_bucket.dart';
import '../models/review_bucket.dart';
import '../models/video_bucket.dart';

class MovieRepository {
  final String _apiKey = ApiCredentials().apiKey;
  final MovieBucket _moviesBucket = MovieBucket();

  Future<List<int>> getMoviesFromServer({
    @required GetMovies queryType,
    // String language = 'en-US',
    String language,
    String pageNumber = '1',
    String region = 'US',
  }) async {
    String _queryPlaceholder;
    switch (queryType) {
      case GetMovies.nowPlaying:
        _queryPlaceholder = 'now_playing';
        break;

      case GetMovies.popular:
        _queryPlaceholder = 'popular';
        break;

      case GetMovies.upcoming:
        _queryPlaceholder = 'upcoming';
        break;

      default:
        _queryPlaceholder = '';
        break;
    }
    String _query =
        "https://api.themoviedb.org/3/movie/$_queryPlaceholder?api_key=$_apiKey&page=$pageNumber&region=$region";
    if (language != null && language != '') {
      _query = "$_query&language=$language";
    }
    List<int> listToReturn = []; //List of Movie IDs
    http.Response response = await http.get(_query);
    // print("Response Status Code: ${response.statusCode}");
    // print("Response Status Body: ${response.body}");
    switch (response.statusCode) {
      case 200:
        final List result =
            // List<Map<String, dynamic>> result =
            (jsonDecode(response.body) as Map<String, dynamic>)['results'];
        // print("result :");
        // print(result);
        result.forEach(
          (element) {
            // print('started');
            listToReturn.add(element['id']);
            // List listToAdd = element['genre_ids'] as List;
            // print(listToAdd);
            _moviesBucket.addInfo(
              id: element['id'],
              genreIds: List<int>.from(element["genre_ids"].map((x) => x)),
              posterImagePath: element['poster_path'],
              releaseDate: element['release_date'],
              summary: element['overview'],
              title: element['title'],
              avgRatingOutOfTen: (element['vote_average'] as num).toDouble(),
              totalRatingCount: (element['vote_count'] as num).toInt(),
            );
            // print('ended');
          },
        );
        // print('listToReturn:');
        // print(listToReturn);
        return listToReturn;

      default:
        // print('For Query: $_query');
        // print("Response Status Code: ${response.statusCode}");
        // print(
        //     "Status Message: ${(jsonDecode(response.body) as Map<String, dynamic>)['status_message']}");
        throw Exception();
    }
  }

  Future<List<String>> getCastInfo({
    @required int movieId,
    String language,
  }) async {
    String _query =
        "https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$_apiKey";
    if (language != null && language != '') {
      _query = "$_query&language=$language";
    }
    http.Response response = await http.get(_query);
    switch (response.statusCode) {
      case 200:
        final List result =
            (jsonDecode(response.body) as Map<String, dynamic>)['cast'];

        List<String> _allCasts = [];

        result.forEach((element) {
          CastBucket().addCast(
              creditId: element['credit_id'],
              person: PersonBucket().addPerson(
                id: element['id'],
                name: element['name'],
                avatarPath: element['profile_path'],
              ),
              characterName: element['character']);
          _allCasts.add(element['credit_id']);
        });

        _moviesBucket.addInfo(id: movieId, casts: _allCasts);
        return _allCasts;

      default:
        // print('For Query: $_query');
        // print("Response Status Code: ${response.statusCode}");
        // print(
        //     "Status Message: ${(jsonDecode(response.body) as Map<String, dynamic>)['status_message']}");
        throw Exception();
    }
  }

  Future<List<String>> getVideos({
    @required int movieId,
    String language,
  }) async {
    String _query =
        "https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$_apiKey";
    if (language != null && language != '') {
      _query = "$_query&language=$language";
    }
    http.Response response = await http.get(_query);
    switch (response.statusCode) {
      case 200:
        final List result =
            (jsonDecode(response.body) as Map<String, dynamic>)['results'];

        List<String> _allVideos = [];

        result.forEach((element) {
          VideoBucket().addVideo(
            id: element['id'],
            path: element['key'],
            title: element['name'],
            provider: element['site'],
          );
          _allVideos.add(element['id']);
        });
        _moviesBucket.addInfo(id: movieId, videos: _allVideos);

        return _allVideos;

      default:
        // print('For Query: $_query');
        // print("Response Status Code: ${response.statusCode}");
        // print(
        //     "Status Message: ${(jsonDecode(response.body) as Map<String, dynamic>)['status_message']}");
        throw Exception();
    }
  }

  Future<List<String>> getReviews({
    @required int movieId,
    int page = 1,
    String language,
  }) async {
    String _query =
        "https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=$_apiKey&page=$page";
    if (language != null && language != '') {
      _query = "$_query&language=$language";
    }
    http.Response response = await http.get(_query);
    switch (response.statusCode) {
      case 200:
        final List result =
            (jsonDecode(response.body) as Map<String, dynamic>)['results'];

        List<String> _allReviews = [];

        result.forEach((element) {
          // print("Id: ${element['id']}");
          // print("Author: ${element['author']}");
          // print("Content: ${element['content']}");
          // print("Rating: ${element['author_details']['rating']}");
          ReviewBucket().addReview(
            id: element['id'],
            author: element['author'],
            content: element['content'],
            rating: element['author_details']['rating'] != null
                ? ((element['author_details'] as Map<String, dynamic>)['rating']
                        as num)
                    .toInt()
                : null,
          );
          _allReviews.add(element['id']);
        });

        // print(
        //     "For movie: ${_moviesBucket.getInfo(movieId).title}, returned: $_allReviews");
        _moviesBucket.addInfo(id: movieId, reviews: _allReviews);
        return _allReviews;

      default:
        // print('For Query: $_query');
        // print("Response Status Code: ${response.statusCode}");
        // print(
        //     "Status Message: ${(jsonDecode(response.body) as Map<String, dynamic>)['status_message']}");
        throw Exception();
    }
  }

  Future<List<int>> getSimilarMovies({
    @required int movieId,
    int page = 1,
    String language,
  }) async {
    String _query =
        "https://api.themoviedb.org/3/movie/$movieId/similar?api_key=$_apiKey&page=$page";
    if (language != null && language != '') {
      _query = "$_query&language=$language";
    }
    http.Response response = await http.get(_query);
    // print("Response Status Code: ${response.statusCode}");
    // print("Response Status Body: ${response.body}");
    switch (response.statusCode) {
      case 200:
        List<int> _listToReturn = []; //List of Movie IDs
        final List result =
            // List<Map<String, dynamic>> result =
            (jsonDecode(response.body) as Map<String, dynamic>)['results'];
        // print("result :");
        // print(result);
        result.forEach(
          (element) {
            // print('started');
            _listToReturn.add(element['id']);
            // List listToAdd = element['genre_ids'] as List;
            // print(listToAdd);
            // print(
            //     'Movie Name: ${element['title']}, id: ${element['id']}, release date: ${element['release_date']}');
            _moviesBucket.addInfo(
              id: element['id'],
              genreIds: List<int>.from(element["genre_ids"].map((x) => x)),
              posterImagePath: element['poster_path'],
              releaseDate: element['release_date'],
              summary: element['overview'],
              title: element['title'],
              avgRatingOutOfTen: (element['vote_average'] as num).toDouble(),
              totalRatingCount: (element['vote_count'] as num).toInt(),
            );
            // print('ended');
          },
        );
        // print('listToReturn:');
        // print(listToReturn);
        _moviesBucket.addInfo(id: movieId, similarMovies: _listToReturn);
        return _listToReturn;

      default:
        // print('For Query: $_query');
        // print("Response Status Code: ${response.statusCode}");
        // print(
        //     "Status Message: ${(jsonDecode(response.body) as Map<String, dynamic>)['status_message']}");
        throw Exception();
    }
  }

  Future<List<int>> searchMovie({
    @required String searchQuery,
    int page = 1,
  }) async {
    // print(
    //     "Searching Movie related to SearchQuery: $searchQuery at Page: $page");
    String _query =
        "https://api.themoviedb.org/3/search/movie?api_key=$_apiKey&query=$searchQuery&page=$page";
    http.Response response = await http.get(_query);
    // print("Response Status Code: ${response.statusCode}");
    // print("Response Status Body: ${response.body}");
    switch (response.statusCode) {
      case 200:
        List<int> _listToReturn = []; //List of Movie IDs
        final List result =
            // List<Map<String, dynamic>> result =
            (jsonDecode(response.body) as Map<String, dynamic>)['results'];
        // print("result :");
        // print(result);
        result.forEach(
          (element) {
            // print('started');

            // List listToAdd = element['genre_ids'] as List;
            // print(listToAdd);
            // print(
            //     'Movie Name: ${element['title']}, id: ${element['id']}, release date: ${element['release_date']}');
            _moviesBucket.addInfo(
              id: element['id'],
              genreIds: List<int>.from(element["genre_ids"].map((x) => x)),
              posterImagePath: element['poster_path'],
              releaseDate: element['release_date'],
              summary: element['overview'],
              title: element['title'],
              avgRatingOutOfTen: (element['vote_average'] as num).toDouble(),
              totalRatingCount: (element['vote_count'] as num).toInt(),
            );
            // print('ended');
            _listToReturn.add(element['id']);
          },
        );
        // print('listToReturn:');
        // print(listToReturn);
        // print("Search Successful");
        return _listToReturn;

      default:
        // print('For Query: $_query');
        // print("Response Status Code: ${response.statusCode}");
        // print(
        //     "Status Message: ${(jsonDecode(response.body) as Map<String, dynamic>)['status_message']}");
        // print("Search UNsuccessful");
        throw Exception();
    }
  }

  Future<int> getMovieRuntime({
    @required int movieId,
    String language,
  }) async {
    String _query =
        "https://api.themoviedb.org/3/movie/$movieId?api_key=$_apiKey";
    if (language != null && language != '') {
      _query = "$_query&language=$language";
    }
    http.Response response = await http.get(_query);
    // print("Response Status Code: ${response.statusCode}");
    // print("Response Status Body: ${response.body}");
    switch (response.statusCode) {
      case 200:
        int _runtimeMinutes; //List of Movie IDs
        final Map element =
            // List<Map<String, dynamic>> result =
            (jsonDecode(response.body) as Map<String, dynamic>);
        // print("result :");
        // print(result);
        // result.forEach(
        //   (element) {
        // print('started');
        // List listToAdd = element['genre_ids'] as List;
        // print(listToAdd);
        // print(
        //     'Movie Name: ${element['title']}, id: ${element['id']}, release date: ${element['release_date']}');
        _moviesBucket.addInfo(
          id: element['id'],
          runtimeMinutes: element['runtime'],
        );

        _runtimeMinutes = element['runtime'];
        // print('ended');
        //   },
        // );
        // print('listToReturn:');
        // print(listToReturn);
        return _runtimeMinutes;

      default:
        // print('For Query: $_query');
        // print("Response Status Code: ${response.statusCode}");
        // print(
        //     "Status Message: ${(jsonDecode(response.body) as Map<String, dynamic>)['status_message']}");
        throw Exception();
    }
  }

  Future<String> getCertification({
    @required int movieId,
  }) async {
    String _query =
        "https://api.themoviedb.org/3/movie/$movieId/release_dates?api_key=$_apiKey";
    http.Response response = await http.get(_query);
    switch (response.statusCode) {
      case 200:
        final List result =
            (jsonDecode(response.body) as Map<String, dynamic>)['results'];

        String indianMovieCertificate;

        String usMovieCertificate;

        String otherMovieCertificate;

        result.forEach((element) {
          String board = element["iso_3166_1"];
          final List allReleases = element["release_dates"];
          allReleases.forEach((element) {
            String certificate = element["certification"];
            if (element["certification"] != "") {
              if (board == 'IN') {
                indianMovieCertificate ??= certificate;
                _moviesBucket.addInfo(
                    id: movieId, certification: indianMovieCertificate);
                return indianMovieCertificate;
              } else if (board == 'US') {
                usMovieCertificate ??= certificate;
              } else {
                var myExp = RegExp(r"^\d{1,2}\+?$");
                if (myExp.hasMatch(certificate)) {
                  otherMovieCertificate ??=
                      myExp.firstMatch(certificate).group(0);
                }
              }
            }
          });
          // print("Id: ${element['id']}");
          // print("Author: ${element['author']}");
          // print("Content: ${element['content']}");
          // print("Rating: ${element['author_details']['rating']}");
          // ReviewBucket().addReview(
          //   id: element['id'],
          //   author: element['author'],
          //   content: element['content'],
          //   rating: element['author_details']['rating'] != null
          //       ? ((element['author_details'] as Map<String, dynamic>)['rating']
          //               as num)
          //           .toInt()
          //       : null,
          // );
          // _allReviews.add(element['id']);
        });

        // print(
        //     "For movie: ${_moviesBucket.getInfo(movieId).title}, returned: $_allReviews");
        // _moviesBucket.addInfo(id: movieId, reviews: _allReviews);
        String movieCertificate =
            usMovieCertificate ?? otherMovieCertificate ?? 'N/A';
        _moviesBucket.addInfo(id: movieId, certification: movieCertificate);
        return movieCertificate;

      default:
        // print('For Query: $_query');
        // print("Response Status Code: ${response.statusCode}");
        // print(
        //     "Status Message: ${(jsonDecode(response.body) as Map<String, dynamic>)['status_message']}");
        throw Exception();
    }
  }
}
