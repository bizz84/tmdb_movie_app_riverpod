enum PosterSize {
  w92,
  w154,
  w185,
  w342,
  w500,
  w780,
  original,
}

Map<PosterSize, String> _posterSizes = {
  PosterSize.w92: "w92",
  PosterSize.w154: "w154",
  PosterSize.w185: "w185",
  PosterSize.w342: "w342",
  PosterSize.w500: "w500",
  PosterSize.w780: "w780",
  PosterSize.original: "original",
};

class TMDBPoster {
  static String tmdbBaseImageUrl = "http://image.tmdb.org/t/p/";

  static String imageUrl(String path, PosterSize size) {
    return tmdbBaseImageUrl + _posterSizes[size]! + path;
  }
}
