import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_movie_app_riverpod/src/api/api_keys.dart';
import 'package:tmdb_movie_app_riverpod/src/api/dio_provider.dart';
import 'package:tmdb_movie_app_riverpod/src/models/search_data.dart';
import 'package:tmdb_movie_app_riverpod/src/models/tmdb/tmdb_movie_basic.dart';
import 'package:tmdb_movie_app_riverpod/src/models/tmdb/tmdb_movies_response.dart';

class MoviesRepository {
  MoviesRepository({required this.client});
  final Dio client;

  Future<List<TMDBMovieBasic>> searchMovies(
      {required int page, String query = '', CancelToken? cancelToken}) async {
    final url = Uri(
      scheme: 'https',
      host: 'api.themoviedb.org',
      path: '3/search/movie',
      queryParameters: {
        'api_key': tmdbApiKey,
        'include_adult': 'false',
        'page': '$page',
        'query': query,
      },
    ).toString();
    final response = await client.get(url);
    final movies = TMDBMoviesResponse.fromJson(response.data);
    return movies.results;
  }

  Future<List<TMDBMovieBasic>> nowPlayingMovies(
      {required int page, CancelToken? cancelToken}) async {
    final url = Uri(
      scheme: 'https',
      host: 'api.themoviedb.org',
      path: '3/movie/now_playing',
      queryParameters: {
        'api_key': tmdbApiKey,
        'include_adult': 'false',
        'page': '$page',
      },
    ).toString();
    final response = await client.get(url);
    final movies = TMDBMoviesResponse.fromJson(response.data);
    return movies.results;
  }
}

final fetchMoviesRepositoryProvider = Provider<MoviesRepository>((ref) {
  return MoviesRepository(
    client: ref.watch(dioProvider),
  );
});

final fetchMoviesProvider =
    FutureProvider.autoDispose.family<List<TMDBMovieBasic>, SearchData>(
  (ref, searchData) async {
    final moviesRepo = ref.watch(fetchMoviesRepositoryProvider);
    // An object from package:dio that allows cancelling http requests
    final cancelToken = CancelToken();
    // When the provider is destroyed, cancel the http request
    ref.onDispose(() => cancelToken.cancel());
    // Use this to test shimmer effect
    await Future.delayed(const Duration(seconds: 2));
    if (searchData.query.isEmpty) {
      return moviesRepo.nowPlayingMovies(
        page: searchData.page,
        cancelToken: cancelToken,
      );
    } else {
      return moviesRepo.searchMovies(
        page: searchData.page,
        query: searchData.query,
        cancelToken: cancelToken,
      );
    }
  },
  cacheTime: const Duration(seconds: 30),
);
