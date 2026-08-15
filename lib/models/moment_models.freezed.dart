// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'moment_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Moment {

 String get id;/// The poster's profile (drives avatar/name + tap-to-preview for others).
 DiscoveryProfile get author; String? get text;/// A network/seed photo URL.
 String? get imageUrl;/// A user-picked photo, zoomed/aligned and baked to PNG bytes. Takes
/// precedence over [imageUrl] when present.
 Uint8List? get imageBytes; Mood? get mood;/// Pre-formatted relative time for the mock (e.g. "2h ago").
 String get timeLabel;/// True when posted by the current user (menu = Edit/Delete).
 bool get isMine;
/// Create a copy of Moment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MomentCopyWith<Moment> get copyWith => _$MomentCopyWithImpl<Moment>(this as Moment, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Moment&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.text, text) || other.text == text)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.imageBytes, imageBytes)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.timeLabel, timeLabel) || other.timeLabel == timeLabel)&&(identical(other.isMine, isMine) || other.isMine == isMine));
}


@override
int get hashCode => Object.hash(runtimeType,id,author,text,imageUrl,const DeepCollectionEquality().hash(imageBytes),mood,timeLabel,isMine);

@override
String toString() {
  return 'Moment(id: $id, author: $author, text: $text, imageUrl: $imageUrl, imageBytes: $imageBytes, mood: $mood, timeLabel: $timeLabel, isMine: $isMine)';
}


}

/// @nodoc
abstract mixin class $MomentCopyWith<$Res>  {
  factory $MomentCopyWith(Moment value, $Res Function(Moment) _then) = _$MomentCopyWithImpl;
@useResult
$Res call({
 String id, DiscoveryProfile author, String? text, String? imageUrl, Uint8List? imageBytes, Mood? mood, String timeLabel, bool isMine
});


$DiscoveryProfileCopyWith<$Res> get author;

}
/// @nodoc
class _$MomentCopyWithImpl<$Res>
    implements $MomentCopyWith<$Res> {
  _$MomentCopyWithImpl(this._self, this._then);

  final Moment _self;
  final $Res Function(Moment) _then;

/// Create a copy of Moment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? author = null,Object? text = freezed,Object? imageUrl = freezed,Object? imageBytes = freezed,Object? mood = freezed,Object? timeLabel = null,Object? isMine = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as DiscoveryProfile,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageBytes: freezed == imageBytes ? _self.imageBytes : imageBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,mood: freezed == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as Mood?,timeLabel: null == timeLabel ? _self.timeLabel : timeLabel // ignore: cast_nullable_to_non_nullable
as String,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of Moment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiscoveryProfileCopyWith<$Res> get author {
  
  return $DiscoveryProfileCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [Moment].
extension MomentPatterns on Moment {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Moment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Moment() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Moment value)  $default,){
final _that = this;
switch (_that) {
case _Moment():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Moment value)?  $default,){
final _that = this;
switch (_that) {
case _Moment() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DiscoveryProfile author,  String? text,  String? imageUrl,  Uint8List? imageBytes,  Mood? mood,  String timeLabel,  bool isMine)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Moment() when $default != null:
return $default(_that.id,_that.author,_that.text,_that.imageUrl,_that.imageBytes,_that.mood,_that.timeLabel,_that.isMine);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DiscoveryProfile author,  String? text,  String? imageUrl,  Uint8List? imageBytes,  Mood? mood,  String timeLabel,  bool isMine)  $default,) {final _that = this;
switch (_that) {
case _Moment():
return $default(_that.id,_that.author,_that.text,_that.imageUrl,_that.imageBytes,_that.mood,_that.timeLabel,_that.isMine);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DiscoveryProfile author,  String? text,  String? imageUrl,  Uint8List? imageBytes,  Mood? mood,  String timeLabel,  bool isMine)?  $default,) {final _that = this;
switch (_that) {
case _Moment() when $default != null:
return $default(_that.id,_that.author,_that.text,_that.imageUrl,_that.imageBytes,_that.mood,_that.timeLabel,_that.isMine);case _:
  return null;

}
}

}

/// @nodoc


class _Moment extends Moment {
  const _Moment({required this.id, required this.author, this.text, this.imageUrl, this.imageBytes, this.mood, required this.timeLabel, this.isMine = false}): super._();
  

@override final  String id;
/// The poster's profile (drives avatar/name + tap-to-preview for others).
@override final  DiscoveryProfile author;
@override final  String? text;
/// A network/seed photo URL.
@override final  String? imageUrl;
/// A user-picked photo, zoomed/aligned and baked to PNG bytes. Takes
/// precedence over [imageUrl] when present.
@override final  Uint8List? imageBytes;
@override final  Mood? mood;
/// Pre-formatted relative time for the mock (e.g. "2h ago").
@override final  String timeLabel;
/// True when posted by the current user (menu = Edit/Delete).
@override@JsonKey() final  bool isMine;

/// Create a copy of Moment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MomentCopyWith<_Moment> get copyWith => __$MomentCopyWithImpl<_Moment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Moment&&(identical(other.id, id) || other.id == id)&&(identical(other.author, author) || other.author == author)&&(identical(other.text, text) || other.text == text)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.imageBytes, imageBytes)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.timeLabel, timeLabel) || other.timeLabel == timeLabel)&&(identical(other.isMine, isMine) || other.isMine == isMine));
}


@override
int get hashCode => Object.hash(runtimeType,id,author,text,imageUrl,const DeepCollectionEquality().hash(imageBytes),mood,timeLabel,isMine);

@override
String toString() {
  return 'Moment(id: $id, author: $author, text: $text, imageUrl: $imageUrl, imageBytes: $imageBytes, mood: $mood, timeLabel: $timeLabel, isMine: $isMine)';
}


}

/// @nodoc
abstract mixin class _$MomentCopyWith<$Res> implements $MomentCopyWith<$Res> {
  factory _$MomentCopyWith(_Moment value, $Res Function(_Moment) _then) = __$MomentCopyWithImpl;
@override @useResult
$Res call({
 String id, DiscoveryProfile author, String? text, String? imageUrl, Uint8List? imageBytes, Mood? mood, String timeLabel, bool isMine
});


@override $DiscoveryProfileCopyWith<$Res> get author;

}
/// @nodoc
class __$MomentCopyWithImpl<$Res>
    implements _$MomentCopyWith<$Res> {
  __$MomentCopyWithImpl(this._self, this._then);

  final _Moment _self;
  final $Res Function(_Moment) _then;

/// Create a copy of Moment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? author = null,Object? text = freezed,Object? imageUrl = freezed,Object? imageBytes = freezed,Object? mood = freezed,Object? timeLabel = null,Object? isMine = null,}) {
  return _then(_Moment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as DiscoveryProfile,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageBytes: freezed == imageBytes ? _self.imageBytes : imageBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,mood: freezed == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as Mood?,timeLabel: null == timeLabel ? _self.timeLabel : timeLabel // ignore: cast_nullable_to_non_nullable
as String,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of Moment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiscoveryProfileCopyWith<$Res> get author {
  
  return $DiscoveryProfileCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}

// dart format on
