/// Metadata used when fetching movies with the paginated search API.
class MoviesPagination {
  MoviesPagination({required this.page, required this.query});
  final int page;
  final String query;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MoviesPagination &&
        other.query == query &&
        other.page == page;
  }

  @override
  int get hashCode => query.hashCode ^ page.hashCode;
}
