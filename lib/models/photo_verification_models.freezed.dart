// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo_verification_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PhotoVerificationData {

 int? get heightFeet; int? get heightInches; int? get heightCm; HeightUnit get heightUnit; List<String> get languages; List<String> get photos; String? get selfiePhotoPath; bool get selfieVerified;
/// Create a copy of PhotoVerificationData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhotoVerificationDataCopyWith<PhotoVerificationData> get copyWith => _$PhotoVerificationDataCopyWithImpl<PhotoVerificationData>(this as PhotoVerificationData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhotoVerificationData&&(identical(other.heightFeet, heightFeet) || other.heightFeet == heightFeet)&&(identical(other.heightInches, heightInches) || other.heightInches == heightInches)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.heightUnit, heightUnit) || other.heightUnit == heightUnit)&&const DeepCollectionEquality().equals(other.languages, languages)&&const DeepCollectionEquality().equals(other.photos, photos)&&(identical(other.selfiePhotoPath, selfiePhotoPath) || other.selfiePhotoPath == selfiePhotoPath)&&(identical(other.selfieVerified, selfieVerified) || other.selfieVerified == selfieVerified));
}


@override
int get hashCode => Object.hash(runtimeType,heightFeet,heightInches,heightCm,heightUnit,const DeepCollectionEquality().hash(languages),const DeepCollectionEquality().hash(photos),selfiePhotoPath,selfieVerified);

@override
String toString() {
  return 'PhotoVerificationData(heightFeet: $heightFeet, heightInches: $heightInches, heightCm: $heightCm, heightUnit: $heightUnit, languages: $languages, photos: $photos, selfiePhotoPath: $selfiePhotoPath, selfieVerified: $selfieVerified)';
}


}

/// @nodoc
abstract mixin class $PhotoVerificationDataCopyWith<$Res>  {
  factory $PhotoVerificationDataCopyWith(PhotoVerificationData value, $Res Function(PhotoVerificationData) _then) = _$PhotoVerificationDataCopyWithImpl;
@useResult
$Res call({
 int? heightFeet, int? heightInches, int? heightCm, HeightUnit heightUnit, List<String> languages, List<String> photos, String? selfiePhotoPath, bool selfieVerified
});




}
/// @nodoc
class _$PhotoVerificationDataCopyWithImpl<$Res>
    implements $PhotoVerificationDataCopyWith<$Res> {
  _$PhotoVerificationDataCopyWithImpl(this._self, this._then);

  final PhotoVerificationData _self;
  final $Res Function(PhotoVerificationData) _then;

/// Create a copy of PhotoVerificationData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? heightFeet = freezed,Object? heightInches = freezed,Object? heightCm = freezed,Object? heightUnit = null,Object? languages = null,Object? photos = null,Object? selfiePhotoPath = freezed,Object? selfieVerified = null,}) {
  return _then(_self.copyWith(
heightFeet: freezed == heightFeet ? _self.heightFeet : heightFeet // ignore: cast_nullable_to_non_nullable
as int?,heightInches: freezed == heightInches ? _self.heightInches : heightInches // ignore: cast_nullable_to_non_nullable
as int?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as int?,heightUnit: null == heightUnit ? _self.heightUnit : heightUnit // ignore: cast_nullable_to_non_nullable
as HeightUnit,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<String>,selfiePhotoPath: freezed == selfiePhotoPath ? _self.selfiePhotoPath : selfiePhotoPath // ignore: cast_nullable_to_non_nullable
as String?,selfieVerified: null == selfieVerified ? _self.selfieVerified : selfieVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PhotoVerificationData].
extension PhotoVerificationDataPatterns on PhotoVerificationData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhotoVerificationData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhotoVerificationData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhotoVerificationData value)  $default,){
final _that = this;
switch (_that) {
case _PhotoVerificationData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhotoVerificationData value)?  $default,){
final _that = this;
switch (_that) {
case _PhotoVerificationData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? heightFeet,  int? heightInches,  int? heightCm,  HeightUnit heightUnit,  List<String> languages,  List<String> photos,  String? selfiePhotoPath,  bool selfieVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhotoVerificationData() when $default != null:
return $default(_that.heightFeet,_that.heightInches,_that.heightCm,_that.heightUnit,_that.languages,_that.photos,_that.selfiePhotoPath,_that.selfieVerified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? heightFeet,  int? heightInches,  int? heightCm,  HeightUnit heightUnit,  List<String> languages,  List<String> photos,  String? selfiePhotoPath,  bool selfieVerified)  $default,) {final _that = this;
switch (_that) {
case _PhotoVerificationData():
return $default(_that.heightFeet,_that.heightInches,_that.heightCm,_that.heightUnit,_that.languages,_that.photos,_that.selfiePhotoPath,_that.selfieVerified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? heightFeet,  int? heightInches,  int? heightCm,  HeightUnit heightUnit,  List<String> languages,  List<String> photos,  String? selfiePhotoPath,  bool selfieVerified)?  $default,) {final _that = this;
switch (_that) {
case _PhotoVerificationData() when $default != null:
return $default(_that.heightFeet,_that.heightInches,_that.heightCm,_that.heightUnit,_that.languages,_that.photos,_that.selfiePhotoPath,_that.selfieVerified);case _:
  return null;

}
}

}

/// @nodoc


class _PhotoVerificationData implements PhotoVerificationData {
  const _PhotoVerificationData({this.heightFeet, this.heightInches, this.heightCm, this.heightUnit = HeightUnit.feet, final  List<String> languages = const [], final  List<String> photos = const [], this.selfiePhotoPath, this.selfieVerified = false}): _languages = languages,_photos = photos;
  

@override final  int? heightFeet;
@override final  int? heightInches;
@override final  int? heightCm;
@override@JsonKey() final  HeightUnit heightUnit;
 final  List<String> _languages;
@override@JsonKey() List<String> get languages {
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_languages);
}

 final  List<String> _photos;
@override@JsonKey() List<String> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

@override final  String? selfiePhotoPath;
@override@JsonKey() final  bool selfieVerified;

/// Create a copy of PhotoVerificationData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhotoVerificationDataCopyWith<_PhotoVerificationData> get copyWith => __$PhotoVerificationDataCopyWithImpl<_PhotoVerificationData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhotoVerificationData&&(identical(other.heightFeet, heightFeet) || other.heightFeet == heightFeet)&&(identical(other.heightInches, heightInches) || other.heightInches == heightInches)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.heightUnit, heightUnit) || other.heightUnit == heightUnit)&&const DeepCollectionEquality().equals(other._languages, _languages)&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.selfiePhotoPath, selfiePhotoPath) || other.selfiePhotoPath == selfiePhotoPath)&&(identical(other.selfieVerified, selfieVerified) || other.selfieVerified == selfieVerified));
}


@override
int get hashCode => Object.hash(runtimeType,heightFeet,heightInches,heightCm,heightUnit,const DeepCollectionEquality().hash(_languages),const DeepCollectionEquality().hash(_photos),selfiePhotoPath,selfieVerified);

@override
String toString() {
  return 'PhotoVerificationData(heightFeet: $heightFeet, heightInches: $heightInches, heightCm: $heightCm, heightUnit: $heightUnit, languages: $languages, photos: $photos, selfiePhotoPath: $selfiePhotoPath, selfieVerified: $selfieVerified)';
}


}

/// @nodoc
abstract mixin class _$PhotoVerificationDataCopyWith<$Res> implements $PhotoVerificationDataCopyWith<$Res> {
  factory _$PhotoVerificationDataCopyWith(_PhotoVerificationData value, $Res Function(_PhotoVerificationData) _then) = __$PhotoVerificationDataCopyWithImpl;
@override @useResult
$Res call({
 int? heightFeet, int? heightInches, int? heightCm, HeightUnit heightUnit, List<String> languages, List<String> photos, String? selfiePhotoPath, bool selfieVerified
});




}
/// @nodoc
class __$PhotoVerificationDataCopyWithImpl<$Res>
    implements _$PhotoVerificationDataCopyWith<$Res> {
  __$PhotoVerificationDataCopyWithImpl(this._self, this._then);

  final _PhotoVerificationData _self;
  final $Res Function(_PhotoVerificationData) _then;

/// Create a copy of PhotoVerificationData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? heightFeet = freezed,Object? heightInches = freezed,Object? heightCm = freezed,Object? heightUnit = null,Object? languages = null,Object? photos = null,Object? selfiePhotoPath = freezed,Object? selfieVerified = null,}) {
  return _then(_PhotoVerificationData(
heightFeet: freezed == heightFeet ? _self.heightFeet : heightFeet // ignore: cast_nullable_to_non_nullable
as int?,heightInches: freezed == heightInches ? _self.heightInches : heightInches // ignore: cast_nullable_to_non_nullable
as int?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as int?,heightUnit: null == heightUnit ? _self.heightUnit : heightUnit // ignore: cast_nullable_to_non_nullable
as HeightUnit,languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<String>,selfiePhotoPath: freezed == selfiePhotoPath ? _self.selfiePhotoPath : selfiePhotoPath // ignore: cast_nullable_to_non_nullable
as String?,selfieVerified: null == selfieVerified ? _self.selfieVerified : selfieVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
