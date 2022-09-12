import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_movie_app_riverpod/src/ui/movies_grid.dart';
import 'package:tmdb_movie_app_riverpod/src/ui/now_playing/now_playing_model.dart';
import 'package:tmdb_movie_app_riverpod/src/ui/scrollable_movies_page_builder.dart';

class NowPlayingPage extends ConsumerWidget {
  const NowPlayingPage({super.key});

  static const moviesGridKey = Key('moviesGrid');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScrollableMoviesPageBuilder(
      title: 'Now Playing',
      onNextPageRequested: () {
        final moviesModel = ref.read(moviesModelProvider.notifier);
        moviesModel.fetchNextPage();
      },
      builder: (_, controller) {
        final state = ref.watch(moviesModelProvider);
        return state.when(
          data: (movies, _) => MoviesGrid(
            key: moviesGridKey,
            movies: movies,
            controller: controller,
          ),
          dataLoading: (movies) {
            return movies.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : MoviesGrid(
                    key: moviesGridKey,
                    movies: movies,
                    controller: controller,
                  );
          },
          error: (error) => Center(child: Text(error)),
        );
      },
    );
  }
}
