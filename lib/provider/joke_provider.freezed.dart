// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'joke_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$JokeState {
// required CardSwiperController cardSwiperController,
  List<JokeCard> get jokes => throw _privateConstructorUsedError;
  List<String> get jokeCategories => throw _privateConstructorUsedError;
  String get currentCategory => throw _privateConstructorUsedError;
  dynamic get isLoading => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $JokeStateCopyWith<JokeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JokeStateCopyWith<$Res> {
  factory $JokeStateCopyWith(JokeState value, $Res Function(JokeState) then) =
      _$JokeStateCopyWithImpl<$Res, JokeState>;
  @useResult
  $Res call(
      {List<JokeCard> jokes,
      List<String> jokeCategories,
      String currentCategory,
      dynamic isLoading});
}

/// @nodoc
class _$JokeStateCopyWithImpl<$Res, $Val extends JokeState>
    implements $JokeStateCopyWith<$Res> {
  _$JokeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jokes = null,
    Object? jokeCategories = null,
    Object? currentCategory = null,
    Object? isLoading = freezed,
  }) {
    return _then(_value.copyWith(
      jokes: null == jokes
          ? _value.jokes
          : jokes // ignore: cast_nullable_to_non_nullable
              as List<JokeCard>,
      jokeCategories: null == jokeCategories
          ? _value.jokeCategories
          : jokeCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      currentCategory: null == currentCategory
          ? _value.currentCategory
          : currentCategory // ignore: cast_nullable_to_non_nullable
              as String,
      isLoading: freezed == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_JokeStateCopyWith<$Res> implements $JokeStateCopyWith<$Res> {
  factory _$$_JokeStateCopyWith(
          _$_JokeState value, $Res Function(_$_JokeState) then) =
      __$$_JokeStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<JokeCard> jokes,
      List<String> jokeCategories,
      String currentCategory,
      dynamic isLoading});
}

/// @nodoc
class __$$_JokeStateCopyWithImpl<$Res>
    extends _$JokeStateCopyWithImpl<$Res, _$_JokeState>
    implements _$$_JokeStateCopyWith<$Res> {
  __$$_JokeStateCopyWithImpl(
      _$_JokeState _value, $Res Function(_$_JokeState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jokes = null,
    Object? jokeCategories = null,
    Object? currentCategory = null,
    Object? isLoading = freezed,
  }) {
    return _then(_$_JokeState(
      jokes: null == jokes
          ? _value._jokes
          : jokes // ignore: cast_nullable_to_non_nullable
              as List<JokeCard>,
      jokeCategories: null == jokeCategories
          ? _value._jokeCategories
          : jokeCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      currentCategory: null == currentCategory
          ? _value.currentCategory
          : currentCategory // ignore: cast_nullable_to_non_nullable
              as String,
      isLoading: freezed == isLoading ? _value.isLoading! : isLoading,
    ));
  }
}

/// @nodoc

class _$_JokeState extends _JokeState {
  const _$_JokeState(
      {final List<JokeCard> jokes = const [],
      final List<String> jokeCategories = const [],
      this.currentCategory = "all",
      this.isLoading = true})
      : _jokes = jokes,
        _jokeCategories = jokeCategories,
        super._();

// required CardSwiperController cardSwiperController,
  final List<JokeCard> _jokes;
// required CardSwiperController cardSwiperController,
  @override
  @JsonKey()
  List<JokeCard> get jokes {
    if (_jokes is EqualUnmodifiableListView) return _jokes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_jokes);
  }

  final List<String> _jokeCategories;
  @override
  @JsonKey()
  List<String> get jokeCategories {
    if (_jokeCategories is EqualUnmodifiableListView) return _jokeCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_jokeCategories);
  }

  @override
  @JsonKey()
  final String currentCategory;
  @override
  @JsonKey()
  final dynamic isLoading;

  @override
  String toString() {
    return 'JokeState(jokes: $jokes, jokeCategories: $jokeCategories, currentCategory: $currentCategory, isLoading: $isLoading)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_JokeState &&
            const DeepCollectionEquality().equals(other._jokes, _jokes) &&
            const DeepCollectionEquality()
                .equals(other._jokeCategories, _jokeCategories) &&
            (identical(other.currentCategory, currentCategory) ||
                other.currentCategory == currentCategory) &&
            const DeepCollectionEquality().equals(other.isLoading, isLoading));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_jokes),
      const DeepCollectionEquality().hash(_jokeCategories),
      currentCategory,
      const DeepCollectionEquality().hash(isLoading));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_JokeStateCopyWith<_$_JokeState> get copyWith =>
      __$$_JokeStateCopyWithImpl<_$_JokeState>(this, _$identity);
}

abstract class _JokeState extends JokeState {
  const factory _JokeState(
      {final List<JokeCard> jokes,
      final List<String> jokeCategories,
      final String currentCategory,
      final dynamic isLoading}) = _$_JokeState;
  const _JokeState._() : super._();

  @override // required CardSwiperController cardSwiperController,
  List<JokeCard> get jokes;
  @override
  List<String> get jokeCategories;
  @override
  String get currentCategory;
  @override
  dynamic get isLoading;
  @override
  @JsonKey(ignore: true)
  _$$_JokeStateCopyWith<_$_JokeState> get copyWith =>
      throw _privateConstructorUsedError;
}
