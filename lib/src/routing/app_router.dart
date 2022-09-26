import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_movie_app_riverpod/src/domain/tmdb_movie_basic.dart';
import 'package:tmdb_movie_app_riverpod/src/presentation/movie/movie_details_screen.dart';
import 'package:tmdb_movie_app_riverpod/src/presentation/search/movies_search_screen.dart';
import 'package:tmdb_movie_app_riverpod/src/routing/scaffold_with_bottom_nav_bar.dart';

enum AppRoute {
  movies,
  movie,
  favorites,
}

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/movies',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithBottomNavBar(child: child);
        },
        routes: [
          // Products
          GoRoute(
              path: '/movies',
              name: AppRoute.movies.name,
              pageBuilder: (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    child: const MoviesSearchScreen(),
                  ),
              routes: [
                GoRoute(
                  path: ':id',
                  name: AppRoute.movie.name,
                  pageBuilder: (context, state) {
                    final id = int.parse(state.params['id'] as String);
                    final movie = state.extra as TMDBMovieBasic?;
                    return MaterialPage(
                      key: state.pageKey,
                      child: MovieDetailsScreen(movieId: id, movie: movie),
                    );
                  },
                )
              ]),
          // Shopping Cart
          GoRoute(
            path: '/favorites',
            name: AppRoute.favorites.name,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: Scaffold(
                appBar: AppBar(title: const Text('Favorites')),
              ),
            ),
          ),
        ],
      ),
    ],
  );
});
