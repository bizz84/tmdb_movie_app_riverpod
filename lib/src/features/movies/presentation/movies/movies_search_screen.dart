import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_movie_app_riverpod/src/features/movies/data/movies_repository.dart';
import 'package:tmdb_movie_app_riverpod/src/features/movies/presentation/movies/movie_list_tile.dart';
import 'package:tmdb_movie_app_riverpod/src/features/movies/presentation/movies/movie_list_tile_shimmer.dart';
import 'package:tmdb_movie_app_riverpod/src/features/movies/presentation/movies/movies_search_bar.dart';
import 'package:tmdb_movie_app_riverpod/src/routing/app_router.dart';

class MoviesSearchScreen extends ConsumerWidget {
  const MoviesSearchScreen({super.key});

  static const pageSize = 20;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(moviesSearchTextProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('TMDB Movies'),
      ),
      body: Column(
        children: [
          const MoviesSearchBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () {
                // dispose all the pages previously fetched. Next read will refresh them
                ref.invalidate(fetchMoviesProvider);
                // keep showing the progress indicator until the first page is fetched
                return ref.read(
                  fetchMoviesProvider(
                    pagination: MoviesPagination(page: 1, query: query),
                  ).future,
                );
              },
              // TODO: Limit item count to pagination results
              child: ListView.custom(
                childrenDelegate: SliverChildBuilderDelegate((context, index) {
                  final page = index ~/ pageSize + 1;
                  final indexInPage = index % pageSize;
                  // use the fact that this is an infinite list to fetch a new page
                  // as soon as the index exceeds the page size
                  // Note that ref.watch is called for up to pageSize items
                  // with the same page and query arguments (but this is ok since data is cached)
                  final moviesList = ref.watch(
                    fetchMoviesProvider(
                        pagination: MoviesPagination(page: page, query: query)),
                  );
                  return moviesList.when(
                    // TODO: Improve error handling
                    error: (err, stack) => Text('Error $err'),
                    loading: () => const MovieListTileShimmer(),
                    data: (movies) {
                      if (indexInPage >= movies.length) {
                        return const MovieListTileShimmer();
                      }
                      final movie = movies[indexInPage];
                      return MovieListTile(
                        movie: movie,
                        debugIndex: index,
                        onPressed: () => context.goNamed(
                          AppRoute.movie.name,
                          params: {'id': movie.id.toString()},
                          extra: movie,
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
