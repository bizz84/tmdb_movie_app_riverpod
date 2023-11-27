// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_movies_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TMDBMoviesResponseImpl _$$TMDBMoviesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$TMDBMoviesResponseImpl(
      page: json['page'] as int,
      results: (json['results'] as List<dynamic>)
          .map((e) => TMDBMovie.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalResults: json['total_results'] as int,
      totalPages: json['total_pages'] as int,
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TMDBMoviesResponseImplToJson(
        _$TMDBMoviesResponseImpl instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.results,
      'total_results': instance.totalResults,
      'total_pages': instance.totalPages,
      'errors': instance.errors,
    };
