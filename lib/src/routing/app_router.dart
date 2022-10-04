import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_movie_app_riverpod/src/domain/tmdb_movie_basic.dart';
import 'package:tmdb_movie_app_riverpod/src/localization/string_hardcoded.dart';
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

final _moviesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'moviesNav');
final _favoritesNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'favoritesNav');

final _tabs = [
  ScaffoldWithNavBarTabItem(
    navigationItem: StackedNavigationItem(
        rootRoutePath: '/movies', navigatorKey: _moviesNavigatorKey),
    icon: const Icon(Icons.search),
    label: 'Search'.hardcoded,
  ),
  ScaffoldWithNavBarTabItem(
    navigationItem: StackedNavigationItem(
        rootRoutePath: '/favorites', navigatorKey: _favoritesNavigatorKey),
    icon: const Icon(Icons.favorite),
    label: 'Favorites'.hardcoded,
  ),
  // ScaffoldWithNavBarTabItem(
  //   navigationItem: StackedNavigationItem(
  //       rootRoutePath: '/account', navigatorKey: _accountNavigatorKey),
  //   icon: const Icon(Icons.person),
  //   label: 'Account',
  // ),
];

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/movies',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      PartitionedShellRoute.stackedNavigationShell(
        stackItems: _tabs
            .map((ScaffoldWithNavBarTabItem e) => e.navigationItem)
            .toList(),
        scaffoldBuilder: (BuildContext context, int currentIndex,
            List<StackedNavigationItemState> itemsState, Widget scaffoldBody) {
          return ScaffoldWithNavBar(
            tabs: _tabs,
            currentIndex: currentIndex,
            itemsState: itemsState,
            body: scaffoldBody,
          );
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
            ],
          ),
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
