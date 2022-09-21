import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_movie_app_riverpod/src/localization/string_hardcoded.dart';
import 'package:tmdb_movie_app_riverpod/src/routing/app_router.dart';

class ScaffoldWithBottomNavBar extends StatefulWidget {
  const ScaffoldWithBottomNavBar({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  State<ScaffoldWithBottomNavBar> createState() =>
      _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState extends State<ScaffoldWithBottomNavBar> {
  @override
  void didUpdateWidget(ScaffoldWithBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    //setState(() => _selectedIndex = widget.index);
  }

  int _selectedIndex = 0;

  void _tap(BuildContext context, int index) {
    setState(() => _selectedIndex = index); // used below

    if (index == 0) {
      // Note: this won't remember the previous state of the route
      // More info here:
      // https://github.com/flutter/flutter/issues/99124
      context.goNamed(AppRoute.search.name);
    } else if (index == 1) {
      context.goNamed(AppRoute.favorites.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // TODO: figure out theming
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        items: [
          // products
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: 'Search'.hardcoded,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: 'Cart'.hardcoded,
          ),
        ],
        onTap: (index) => _tap(context, index),
      ),
    );
  }
}
