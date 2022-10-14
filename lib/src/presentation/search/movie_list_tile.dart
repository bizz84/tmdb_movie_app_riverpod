import 'package:flutter/material.dart';
import 'package:tmdb_movie_app_riverpod/src/domain/tmdb_movie.dart';
import 'package:tmdb_movie_app_riverpod/src/presentation/common/movie_poster.dart';
import 'package:tmdb_movie_app_riverpod/src/presentation/common/top_gradient.dart';

class MovieListTile extends StatelessWidget {
  const MovieListTile({
    super.key,
    required this.movie,
    // debugging hint to show the tile index
    this.debugIndex,
    this.onPressed,
  });
  final TMDBMovie movie;
  final int? debugIndex;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: onPressed,
            child: Stack(
              children: [
                SizedBox(
                  width: MoviePoster.width,
                  height: MoviePoster.height,
                  child: MoviePoster(imagePath: movie.posterPath),
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
