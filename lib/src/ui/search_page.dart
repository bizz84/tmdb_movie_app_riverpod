import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_movie_app_riverpod/src/api/movies_repository.dart';
import 'package:tmdb_movie_app_riverpod/src/ui/movie_list_tile.dart';
import 'package:tmdb_movie_app_riverpod/src/ui/movie_list_tile_shimmer.dart';
import 'package:tmdb_movie_app_riverpod/src/ui/search_bar.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  static const pageSize = 20;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchTextProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('TMDB Movies Search'),
      ),
      body: Column(
        children: [
          const SearchBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () {
                // disposes the pages previously fetched. Next read will refresh them
                // TODO: How to dispose data for all pages?
                ref.invalidate(fetchMoviesProvider(
                    MoviesPagination(page: 1, query: query)));
                // keep showing the progress indicator until the first page is fetched
                return ref.read(
                  fetchMoviesProvider(MoviesPagination(page: 1, query: query))
                      .future,
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
                        MoviesPagination(page: page, query: query)),
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
