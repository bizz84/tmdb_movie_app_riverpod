import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_movie_app_riverpod/src/data/movies_repository.dart';
import 'package:tmdb_movie_app_riverpod/src/domain/tmdb_movie_basic.dart';
import 'package:tmdb_movie_app_riverpod/src/presentation/search/movie_list_tile.dart';
import 'package:tmdb_movie_app_riverpod/src/presentation/search/movie_list_tile_shimmer.dart';

class MovieDetailsScreen extends ConsumerWidget {
  const MovieDetailsScreen(
      {super.key, required this.movieId, required this.movie});
  final int movieId;
  final TMDBMovieBasic? movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (movie != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(movie!.title),
        ),
        body: Column(
          children: [
            MovieListTile(movie: movie!),
          ],
        ),
      );
    } else {
      final movieAsync = ref.watch(movieProvider(movieId));
      return movieAsync.when(
        error: (e, st) => Scaffold(
          appBar: AppBar(
            title: Text(movie?.title ?? 'Error'),
          ),
          body: Center(child: Text(e.toString())),
        ),
        loading: () => Scaffold(
          appBar: AppBar(
            title: Text(movie?.title ?? 'Loading'),
          ),
          body: Column(
            children: const [
              MovieListTileShimmer(),
            ],
          ),
        ),
        data: (movie) => Scaffold(
          appBar: AppBar(
            title: Text(movie.title),
          ),
          body: Column(
            children: [
              MovieListTile(movie: movie),
            ],
          ),
        ),
      );
    }
  }
}
