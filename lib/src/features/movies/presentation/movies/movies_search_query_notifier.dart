import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movies_search_query_notifier.g.dart';

/// A notifier class to keep track of the search query (with debouncing)
@riverpod
class MoviesSearchQueryNotifier extends _$MoviesSearchQueryNotifier {
  /// Used to debounce the input queries
  Timer? _debounceTimer;

  @override
  String build() {
    // don't forget to close the StreamController and cancel the subscriptions on dispose
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });
    // by default, return an empty query
    return '';
  }

  void setQuery(String query) {
    // Cancel the timer if it is active
    if (_debounceTimer != null) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      // only update the state once the query has been debounced
      state = query;
    });
  }
}
