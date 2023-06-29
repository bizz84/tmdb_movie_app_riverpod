import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_movie_app_riverpod/src/features/favorites/presentation/favorites_screen.dart';
import 'package:tmdb_movie_app_riverpod/src/features/movies/domain/tmdb_movie.dart';
import 'package:tmdb_movie_app_riverpod/src/features/movies/presentation/movie_details/movie_details_screen.dart';
import 'package:tmdb_movie_app_riverpod/src/features/movies/presentation/movies/movies_search_screen.dart';
import 'package:tmdb_movie_app_riverpod/src/routing/scaffold_with_nested_navigation.dart';

enum AppRoute {
  movies,
  movie,
  favorites,
}

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _searchNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'search');
final _favoritesNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'favorites');

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/movies',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      // Stateful navigation based on:
      // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _searchNavigatorKey,
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
                      final id =
                          int.parse(state.pathParameters['id'] as String);
                      final movie = state.extra as TMDBMovie?;
                      return MaterialPage(
                        key: state.pageKey,
                        child: MovieDetailsScreen(movieId: id, movie: movie),
                      );
                    },
                  )
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _favoritesNavigatorKey,
            routes: [
              // Shopping Cart
              GoRoute(
                path: '/favorites',
                name: AppRoute.favorites.name,
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const FavoritesScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
