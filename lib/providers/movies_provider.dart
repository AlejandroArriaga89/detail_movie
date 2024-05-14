import 'dart:async';

import 'package:detail_movie/helpers/debouncer.dart';
import 'package:detail_movie/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '399cc60f857a6eccd8f14dc211ee5164';
  final String _language = 'es-MX';
  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};
  Map<int, List<Video>> movieVideo = {};

  int _popularPage = 0;
  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );
  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream {
    return _suggestionStreamController.stream;
  }

  MoviesProvider() {
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });
    var response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    // Await the http get response, then decode the json-formatted response.
    // final Map<String, dynamic> decodedData = json.decode(response.body);
    // if (response.statusCode != 200) return print('error');
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPLayingResponse = NowPlayingResponse.fromJson(jsonData);
    onDisplayMovies = nowPLayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;

    // final Map<String, dynamic> decodedData = json.decode(response.body);
    // if (response.statusCode != 200) return print('error');

    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = NowPlayingResponse.fromJson(jsonData);
    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  Future<List<Video>> getMovieVideo(int movieId) async {
    if (movieVideo.containsKey(movieId)) return movieVideo[movieId]!;

    final jsonData = await _getJsonData('3/movie/$movieId/videos');
    final videoResponse = VideoResponse.fromJson(jsonData);

    movieVideo[movieId] = videoResponse.results;
    print(videoResponse.results);
    return videoResponse.results;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query,
    });
    var response = await http.get(url);
    final searchMovieResponse = SearchMovieResponse.fromJson(response.body);
    return searchMovieResponse.results;
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      // print('Tenemos valor a buscar: $value');
      final results = await searchMovie(value);
      _suggestionStreamController.add(results);
    };
    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}
