import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_movie_app_riverpod/src/data/dio_provider.dart';
import 'package:tmdb_movie_app_riverpod/src/domain/tmdb_movie_basic.dart';
import 'package:tmdb_movie_app_riverpod/src/domain/tmdb_movies_response.dart';

class MoviesRepository {
  MoviesRepository({required this.client, required this.apiKey});
  final Dio client;
  final String apiKey;

  Future<List<TMDBMovieBasic>> searchMovies(
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

  Future<List<TMDBMovieBasic>> nowPlayingMovies(
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
}

final fetchMoviesRepositoryProvider = Provider<MoviesRepository>((ref) {
  return MoviesRepository(
    client: ref.watch(dioProvider),
    apiKey: dotenv.env['TMDB_KEY']!,
  );
});

class AbortedException implements Exception {}

final fetchMoviesProvider =
    FutureProvider.autoDispose.family<List<TMDBMovieBasic>, MoviesPagination>(
  (ref, searchData) async {
    final moviesRepo = ref.watch(fetchMoviesRepositoryProvider);
    // Cancel the page request if the UI no longer needs it before the request
    // is finished.
    // This typically happen if the user scrolls very fast
    // or if we type a different search term.
    final cancelToken = CancelToken();
    ref.onDispose(() => cancelToken.cancel());

    if (searchData.query.isEmpty) {
      // use non-search endpoint
      return moviesRepo.nowPlayingMovies(
        page: searchData.page,
        cancelToken: cancelToken,
      );
    } else {
      // Debouncing the request. By having this delay, it leaves the opportunity
      // for consumers to subscribe to a different `meta` parameters. In which
      // case, this request will be aborted.
      await Future.delayed(const Duration(milliseconds: 500));
      if (cancelToken.isCancelled) throw AbortedException();
      // use search endpoint
      return moviesRepo.searchMovies(
        page: searchData.page,
        query: searchData.query,
        cancelToken: cancelToken,
      );
    }
  },
  // When a page is no-longer use, keep it in the cache.
  // After this point, if the list of characters is requested again, a new fetch
  // will be performed.
  cacheTime: const Duration(seconds: 30),
);

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
