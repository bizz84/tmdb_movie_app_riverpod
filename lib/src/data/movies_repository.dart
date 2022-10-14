import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_movie_app_riverpod/env/env.dart';
import 'package:tmdb_movie_app_riverpod/src/data/cancel_token_ref.dart';
import 'package:tmdb_movie_app_riverpod/src/data/dio_provider.dart';
import 'package:tmdb_movie_app_riverpod/src/domain/tmdb_movie.dart';
import 'package:tmdb_movie_app_riverpod/src/domain/tmdb_movies_response.dart';

class MoviesRepository {
  MoviesRepository({required this.client, required this.apiKey});
  final Dio client;
  final String apiKey;

  Future<List<TMDBMovie>> searchMovies(
      {required int page, String query = '', CancelToken? cancelToken}) async {
    final url = Uri(
      scheme: 'https',
      host: 'api.themoviedb.org',
      path: '3/search/movie',
      queryParameters: {
        'api_key': apiKey,
        'include_adult': 'false',
        'page': '$page',
        'query': query,
      },
    ).toString();
    final response = await client.get(url);
    final movies = TMDBMoviesResponse.fromJson(response.data);
    return movies.results;
  }

  Future<List<TMDBMovie>> nowPlayingMovies(
      {required int page, CancelToken? cancelToken}) async {
    final url = Uri(
      scheme: 'https',
      host: 'api.themoviedb.org',
      path: '3/movie/now_playing',
      queryParameters: {
        'api_key': apiKey,
        'include_adult': 'false',
        'page': '$page',
      },
    ).toString();
    final response = await client.get(url);
    final movies = TMDBMoviesResponse.fromJson(response.data);
    return movies.results;
  }

  Future<TMDBMovie> movie(
      {required int movieId, CancelToken? cancelToken}) async {
    final url = Uri(
      scheme: 'https',
      host: 'api.themoviedb.org',
      path: '3/movie/$movieId',
      queryParameters: {
        'api_key': apiKey,
        'include_adult': 'false',
      },
    ).toString();
    final response = await client.get(url);
    return TMDBMovie.fromJson(response.data);
  }
}

final moviesRepositoryProvider = Provider<MoviesRepository>((ref) {
  return MoviesRepository(
    client: ref.watch(dioProvider),
    apiKey: Env.tmdbApiKey,
  );
});

class AbortedException implements Exception {}

final movieProvider =
    FutureProvider.autoDispose.family<TMDBMovie, int>((ref, movieId) async {
  final moviesRepo = ref.watch(moviesRepositoryProvider);
  final cancelToken = ref.cancelToken();
  return moviesRepo.movie(movieId: movieId, cancelToken: cancelToken);
});

final fetchMoviesProvider = FutureProvider.autoDispose
    .family<List<TMDBMovie>, MoviesPagination>((ref, pagination) async {
  final moviesRepo = ref.watch(moviesRepositoryProvider);
  // Cancel the page request if the UI no longer needs it.
  // This happens if the user scrolls very fast or if we type a different search
  // term.
  final cancelToken = CancelToken();
  // When a page is no-longer used, keep it in the cache.
  final link = ref.keepAlive();
  final timer = Timer(const Duration(seconds: 30), () {
    link.close();
  });
  ref.onDispose(() {
    cancelToken.cancel();
    timer.cancel();
  });
  if (pagination.query.isEmpty) {
    // use non-search endpoint
    return moviesRepo.nowPlayingMovies(
      page: pagination.page,
      cancelToken: cancelToken,
    );
  } else {
    // Debounce the request. By having this delay, consumers can subscribe to
    // different parameters. In which case, this request will be aborted.
    await Future.delayed(const Duration(milliseconds: 500));
    if (cancelToken.isCancelled) throw AbortedException();
    // use search endpoint
    return moviesRepo.searchMovies(
      page: pagination.page,
      query: pagination.query,
      cancelToken: cancelToken,
    );
  }
});

class MoviesPagination {
  MoviesPagination({required this.page, required this.query});
  final int page;
  final String query;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MoviesPagination &&
        other.query == query &&
        other.page == page;
  }

  @override
  int get hashCode => query.hashCode ^ page.hashCode;
}
