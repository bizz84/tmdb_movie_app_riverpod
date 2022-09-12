import 'package:flutter/material.dart';
import 'package:tmdb_movie_app_riverpod/src/api/tmdb_poster.dart';
import 'package:tmdb_movie_app_riverpod/src/models/tmdb/tmdb_movie_basic.dart';
import 'package:tmdb_movie_app_riverpod/src/ui/top_gradient.dart';
import 'package:transparent_image/transparent_image.dart';

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
    // return ListTile(
    //   leading: Stack(
    //     children: [
    //       SizedBox(
    //         width: 154,
    //         height: 208,
    //         child: _Poster(imagePath: movie.posterPath),
    //       ),
    //       if (debugIndex != null) ...[
    //         const Positioned.fill(child: TopGradient()),
    //         Positioned(
    //           left: 8,
    //           top: 8,
    //           child: Text(
    //             '$debugIndex',
    //             style: const TextStyle(color: Colors.white, fontSize: 14),
    //           ),
    //         ),
    //       ]
    //     ],
    //   ),
    //   title: Text(movie.title),
    //   subtitle: Text('Released: ${movie.releaseDate}'),
    // );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Stack(
            children: [
              SizedBox(
                width: 154,
                height: 208,
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
                  // https://stackoverflow.com/questions/69059755/flutter-listview-text-show-on-multiline-if-overflow
                  maxLines: 3,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
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
      return FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: TMDBPoster.imageUrl(imagePath!, PosterSize.w154),
        fit: BoxFit.fitWidth,
      );
    }
    return const Placeholder(
      color: Colors.black87,
    );
    //Image.memory(kTransparentImage);
  }
}
