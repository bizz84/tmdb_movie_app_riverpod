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
    final query = ref.watch(moviesSearchQueryNotifierProvider);
    // * get the first page so we can retrieve the total number of results
    final responseAsync = ref.watch(
      fetchMoviesProvider(pagination: (page: 1, query: query)),
    );
    final totalResults = responseAsync.valueOrNull?.totalResults;
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
                    pagination: (page: 1, query: query),
                  ).future,
                );
              },
              child: ListView.builder(
                // * pass the itemCount explicitly to prevent unnecessary renders
                // * during overscroll
                itemCount: totalResults,
                itemBuilder: (context, index) {
                  final page = index ~/ pageSize + 1;
                  final indexInPage = index % pageSize;
                  // use the fact that this is an infinite list to fetch a new page
                  // as soon as the index exceeds the page size
                  // Note that ref.watch is called for up to pageSize items
                  // with the same page and query arguments (but this is ok since data is cached)
                  final responseAsync = ref.watch(
                    fetchMoviesProvider(pagination: (page: page, query: query)),
                  );
                  return responseAsync.when(
                    // * Only show error on the first item of the page
                    error: (err, stack) => indexInPage == 0
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(err.toString()),
                          )
                        : const SizedBox.shrink(),
                    loading: () => const MovieListTileShimmer(),
                    data: (response) {
                      //log('index: $index, page: $page, indexInPage: $indexInPage, len: ${response.results.length}');
                      // * This condition only happens if a null itemCount is given
                      if (indexInPage >= response.results.length) {
                        return null;
                      }
                      final movie = response.results[indexInPage];
                      return MovieListTile(
                        movie: movie,
                        debugIndex: index,
                        onPressed: () => context.goNamed(
                          AppRoute.movie.name,
                          pathParameters: {'id': movie.id.toString()},
                          extra: movie,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
