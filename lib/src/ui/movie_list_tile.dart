import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdb_movie_app_riverpod/src/models/tmdb/tmdb_poster.dart';
import 'package:tmdb_movie_app_riverpod/src/models/tmdb/tmdb_movie_basic.dart';
import 'package:tmdb_movie_app_riverpod/src/ui/top_gradient.dart';

const posterWidth = 154.0;
const posterHeight = 231.0;

class MovieListTile extends StatelessWidget {
  const MovieListTile({
    super.key,
    required this.movie,
    // debugging hint to show the tile index
    this.debugIndex,
  });
  final TMDBMovieBasic movie;
  final int? debugIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Stack(
            children: [
              SizedBox(
                width: posterWidth,
                height: posterHeight,
                child: _Poster(imagePath: movie.posterPath),
              ),
              if (debugIndex != null) ...[
                const Positioned.fill(child: TopGradient()),
                Positioned(
                  left: 8,
                  top: 8,
                  child: Text(
                    '$debugIndex',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ]
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                if (movie.releaseDate != null) ...[
                  const SizedBox(height: 8),
                  Text('Released: ${movie.releaseDate}'),
                ],
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster({this.imagePath});
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    if (imagePath != null) {
      return CachedNetworkImage(
        //fit: BoxFit.fitWidth,
        imageUrl: TMDBPoster.imageUrl(imagePath!, PosterSize.w154),
        placeholder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.black26,
          highlightColor: Colors.black12,
          child: Container(
            width: posterWidth,
            height: posterHeight,
            color: Colors.black,
          ),
        ),
      );
    }
    return const Placeholder(
      color: Colors.black87,
    );
  }
}
