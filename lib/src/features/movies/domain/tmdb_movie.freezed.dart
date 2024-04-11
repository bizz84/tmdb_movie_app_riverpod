// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tmdb_movie.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TMDBMovie _$TMDBMovieFromJson(Map<String, dynamic> json) {
  return _TMDBMovieBasic.fromJson(json);
}

/// @nodoc
mixin _$TMDBMovie {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'poster_path')
  String? get posterPath => throw _privateConstructorUsedError;
  @JsonKey(name: 'release_date')
  String? get releaseDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TMDBMovieCopyWith<TMDBMovie> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TMDBMovieCopyWith<$Res> {
  factory $TMDBMovieCopyWith(TMDBMovie value, $Res Function(TMDBMovie) then) =
      _$TMDBMovieCopyWithImpl<$Res, TMDBMovie>;
  @useResult
  $Res call(
      {int id,
      String title,
      @JsonKey(name: 'poster_path') String? posterPath,
      @JsonKey(name: 'release_date') String? releaseDate});
}

/// @nodoc
class _$TMDBMovieCopyWithImpl<$Res, $Val extends TMDBMovie>
    implements $TMDBMovieCopyWith<$Res> {
  _$TMDBMovieCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? posterPath = freezed,
    Object? releaseDate = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      posterPath: freezed == posterPath
          ? _value.posterPath
          : posterPath // ignore: cast_nullable_to_non_nullable
              as String?,
      releaseDate: freezed == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TMDBMovieBasicImplCopyWith<$Res>
    implements $TMDBMovieCopyWith<$Res> {
  factory _$$TMDBMovieBasicImplCopyWith(_$TMDBMovieBasicImpl value,
          $Res Function(_$TMDBMovieBasicImpl) then) =
      __$$TMDBMovieBasicImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      @JsonKey(name: 'poster_path') String? posterPath,
      @JsonKey(name: 'release_date') String? releaseDate});
}

/// @nodoc
class __$$TMDBMovieBasicImplCopyWithImpl<$Res>
    extends _$TMDBMovieCopyWithImpl<$Res, _$TMDBMovieBasicImpl>
    implements _$$TMDBMovieBasicImplCopyWith<$Res> {
  __$$TMDBMovieBasicImplCopyWithImpl(
      _$TMDBMovieBasicImpl _value, $Res Function(_$TMDBMovieBasicImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? posterPath = freezed,
    Object? releaseDate = freezed,
  }) {
    return _then(_$TMDBMovieBasicImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      posterPath: freezed == posterPath
          ? _value.posterPath
          : posterPath // ignore: cast_nullable_to_non_nullable
              as String?,
      releaseDate: freezed == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TMDBMovieBasicImpl implements _TMDBMovieBasic {
  _$TMDBMovieBasicImpl(
      {required this.id,
      required this.title,
      @JsonKey(name: 'poster_path') this.posterPath,
      @JsonKey(name: 'release_date') this.releaseDate});

  factory _$TMDBMovieBasicImpl.fromJson(Map<String, dynamic> json) =>
      _$$TMDBMovieBasicImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @override
  @JsonKey(name: 'release_date')
  final String? releaseDate;

  @override
  String toString() {
    return 'TMDBMovie(id: $id, title: $title, posterPath: $posterPath, releaseDate: $releaseDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TMDBMovieBasicImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.posterPath, posterPath) ||
                other.posterPath == posterPath) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, posterPath, releaseDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TMDBMovieBasicImplCopyWith<_$TMDBMovieBasicImpl> get copyWith =>
      __$$TMDBMovieBasicImplCopyWithImpl<_$TMDBMovieBasicImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TMDBMovieBasicImplToJson(
      this,
    );
  }
}

abstract class _TMDBMovieBasic implements TMDBMovie {
  factory _TMDBMovieBasic(
          {required final int id,
          required final String title,
          @JsonKey(name: 'poster_path') final String? posterPath,
          @JsonKey(name: 'release_date') final String? releaseDate}) =
      _$TMDBMovieBasicImpl;

  factory _TMDBMovieBasic.fromJson(Map<String, dynamic> json) =
      _$TMDBMovieBasicImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  @JsonKey(name: 'poster_path')
  String? get posterPath;
  @override
  @JsonKey(name: 'release_date')
  String? get releaseDate;
  @override
  @JsonKey(ignore: true)
  _$$TMDBMovieBasicImplCopyWith<_$TMDBMovieBasicImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
