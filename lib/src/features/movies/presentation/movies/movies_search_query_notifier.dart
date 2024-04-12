import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movies_search_query_notifier.g.dart';

/// A notifier class to keep track of the search query (with debouncing)
@riverpod
class MoviesSearchQueryNotifier extends _$MoviesSearchQueryNotifier {
  /// Used to debounce the input queries
  final _searchQueryController = StreamController<String>.broadcast();
  Timer? _debounceTimer;
  late final StreamSubscription<String> _subscription;

  @override
  String build() {
    // Listen to the stream of input queries
    _subscription = _searchQueryController.stream.listen((query) {
      // Cancel existing timer if there is one
      _debounceTimer?.cancel();
      // Set a new timer to debounce the query
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        _updateState(query);
      });
    });

    // don't forget to close the StreamController and cancel the subscriptions on dispose
    ref.onDispose(() {
      _searchQueryController.close();
      _subscription.cancel();
      _debounceTimer?.cancel();
    });

    // by default, return an empty query
    return '';
  }

  void _updateState(String query) {
    // only update the state once the query has been debounced
    state = query;
  }

  void setQuery(String query) {
    _searchQueryController.sink.add(query);
  }
}
