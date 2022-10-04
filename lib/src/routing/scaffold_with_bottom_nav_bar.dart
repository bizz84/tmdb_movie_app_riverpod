import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Representation of a tab item in a [ScaffoldWithNavBar]
class ScaffoldWithNavBarTabItem extends BottomNavigationBarItem {
  /// Constructs an [ScaffoldWithNavBarTabItem].
  const ScaffoldWithNavBarTabItem(
      {required this.navigationItem, required Widget icon, String? label})
      : super(icon: icon, label: label);

  /// The [StackedNavigationItem]
  final StackedNavigationItem navigationItem;

  /// Gets the associated navigator key
  GlobalKey<NavigatorState> get navigatorKey => navigationItem.navigatorKey;
}

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class ScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar({
    required this.currentIndex,
    required this.itemsState,
    required this.body,
    required this.tabs,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  /// Currently active tab index
  final int currentIndex;

  /// Route state
  final List<StackedNavigationItemState> itemsState;

  /// Body, i.e. the index stack
  final Widget body;

  /// The tabs
  final List<ScaffoldWithNavBarTabItem> tabs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        items: tabs,
        currentIndex: currentIndex,
        onTap: (int tappedIndex) =>
            _onItemTapped(context, itemsState[tappedIndex]),
      ),
    );
  }

  void _onItemTapped(
      BuildContext context, StackedNavigationItemState itemState) {
    GoRouter.of(context).go(itemState.currentLocation);
  }
}
