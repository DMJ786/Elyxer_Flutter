// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gender_identity_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GenderIdentityOption {

 String get id; String get label;
/// Create a copy of GenderIdentityOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenderIdentityOptionCopyWith<GenderIdentityOption> get copyWith => _$GenderIdentityOptionCopyWithImpl<GenderIdentityOption>(this as GenderIdentityOption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenderIdentityOption&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,id,label);

@override
String toString() {
  return 'GenderIdentityOption(id: $id, label: $label)';
}


}

/// @nodoc
abstract mixin class $GenderIdentityOptionCopyWith<$Res>  {
  factory $GenderIdentityOptionCopyWith(GenderIdentityOption value, $Res Function(GenderIdentityOption) _then) = _$GenderIdentityOptionCopyWithImpl;
@useResult
$Res call({
 String id, String label
});




}
/// @nodoc
class _$GenderIdentityOptionCopyWithImpl<$Res>
    implements $GenderIdentityOptionCopyWith<$Res> {
  _$GenderIdentityOptionCopyWithImpl(this._self, this._then);

  final GenderIdentityOption _self;
  final $Res Function(GenderIdentityOption) _then;

/// Create a copy of GenderIdentityOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GenderIdentityOption].
extension GenderIdentityOptionPatterns on GenderIdentityOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenderIdentityOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenderIdentityOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenderIdentityOption value)  $default,){
final _that = this;
switch (_that) {
case _GenderIdentityOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenderIdentityOption value)?  $default,){
final _that = this;
switch (_that) {
case _GenderIdentityOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenderIdentityOption() when $default != null:
return $default(_that.id,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label)  $default,) {final _that = this;
switch (_that) {
case _GenderIdentityOption():
return $default(_that.id,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label)?  $default,) {final _that = this;
switch (_that) {
case _GenderIdentityOption() when $default != null:
return $default(_that.id,_that.label);case _:
  return null;

}
}

}

/// @nodoc


class _GenderIdentityOption implements GenderIdentityOption {
  const _GenderIdentityOption({required this.id, required this.label});
  

@override final  String id;
@override final  String label;

/// Create a copy of GenderIdentityOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenderIdentityOptionCopyWith<_GenderIdentityOption> get copyWith => __$GenderIdentityOptionCopyWithImpl<_GenderIdentityOption>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenderIdentityOption&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,id,label);

@override
String toString() {
  return 'GenderIdentityOption(id: $id, label: $label)';
}


}

/// @nodoc
abstract mixin class _$GenderIdentityOptionCopyWith<$Res> implements $GenderIdentityOptionCopyWith<$Res> {
  factory _$GenderIdentityOptionCopyWith(_GenderIdentityOption value, $Res Function(_GenderIdentityOption) _then) = __$GenderIdentityOptionCopyWithImpl;
@override @useResult
$Res call({
 String id, String label
});




}
/// @nodoc
class __$GenderIdentityOptionCopyWithImpl<$Res>
    implements _$GenderIdentityOptionCopyWith<$Res> {
  __$GenderIdentityOptionCopyWithImpl(this._self, this._then);

  final _GenderIdentityOption _self;
  final $Res Function(_GenderIdentityOption) _then;

/// Create a copy of GenderIdentityOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,}) {
  return _then(_GenderIdentityOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
