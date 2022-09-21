import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_movie_app_riverpod/src/presentation/movies_search_page.dart';
import 'package:tmdb_movie_app_riverpod/src/routing/scaffold_with_bottom_nav_bar.dart';

enum AppRoute {
  search,
  favorites,
}

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/search',
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
            path: '/search',
            name: AppRoute.search.name,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              restorationId: state.pageKey.value,
              child: const MoviesSearchPage(),
            ),
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
