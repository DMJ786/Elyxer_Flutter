// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'interest_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SentVibe {

 String get id; String get profileId; String get profileName; VibeContext get context;/// For a Join-Me-For vibe: which option was picked. Null otherwise.
 String? get joinMeForOption; DateTime get sentAt;
/// Create a copy of SentVibe
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SentVibeCopyWith<SentVibe> get copyWith => _$SentVibeCopyWithImpl<SentVibe>(this as SentVibe, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SentVibe&&(identical(other.id, id) || other.id == id)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.profileName, profileName) || other.profileName == profileName)&&(identical(other.context, context) || other.context == context)&&(identical(other.joinMeForOption, joinMeForOption) || other.joinMeForOption == joinMeForOption)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,profileId,profileName,context,joinMeForOption,sentAt);

@override
String toString() {
  return 'SentVibe(id: $id, profileId: $profileId, profileName: $profileName, context: $context, joinMeForOption: $joinMeForOption, sentAt: $sentAt)';
}


}

/// @nodoc
abstract mixin class $SentVibeCopyWith<$Res>  {
  factory $SentVibeCopyWith(SentVibe value, $Res Function(SentVibe) _then) = _$SentVibeCopyWithImpl;
@useResult
$Res call({
 String id, String profileId, String profileName, VibeContext context, String? joinMeForOption, DateTime sentAt
});




}
/// @nodoc
class _$SentVibeCopyWithImpl<$Res>
    implements $SentVibeCopyWith<$Res> {
  _$SentVibeCopyWithImpl(this._self, this._then);

  final SentVibe _self;
  final $Res Function(SentVibe) _then;

/// Create a copy of SentVibe
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? profileId = null,Object? profileName = null,Object? context = null,Object? joinMeForOption = freezed,Object? sentAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String,profileName: null == profileName ? _self.profileName : profileName // ignore: cast_nullable_to_non_nullable
as String,context: null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as VibeContext,joinMeForOption: freezed == joinMeForOption ? _self.joinMeForOption : joinMeForOption // ignore: cast_nullable_to_non_nullable
as String?,sentAt: null == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SentVibe].
extension SentVibePatterns on SentVibe {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SentVibe value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SentVibe() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SentVibe value)  $default,){
final _that = this;
switch (_that) {
case _SentVibe():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SentVibe value)?  $default,){
final _that = this;
switch (_that) {
case _SentVibe() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String profileId,  String profileName,  VibeContext context,  String? joinMeForOption,  DateTime sentAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SentVibe() when $default != null:
return $default(_that.id,_that.profileId,_that.profileName,_that.context,_that.joinMeForOption,_that.sentAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String profileId,  String profileName,  VibeContext context,  String? joinMeForOption,  DateTime sentAt)  $default,) {final _that = this;
switch (_that) {
case _SentVibe():
return $default(_that.id,_that.profileId,_that.profileName,_that.context,_that.joinMeForOption,_that.sentAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String profileId,  String profileName,  VibeContext context,  String? joinMeForOption,  DateTime sentAt)?  $default,) {final _that = this;
switch (_that) {
case _SentVibe() when $default != null:
return $default(_that.id,_that.profileId,_that.profileName,_that.context,_that.joinMeForOption,_that.sentAt);case _:
  return null;

}
}

}

/// @nodoc


class _SentVibe implements SentVibe {
  const _SentVibe({required this.id, required this.profileId, required this.profileName, required this.context, this.joinMeForOption, required this.sentAt});
  

@override final  String id;
@override final  String profileId;
@override final  String profileName;
@override final  VibeContext context;
/// For a Join-Me-For vibe: which option was picked. Null otherwise.
@override final  String? joinMeForOption;
@override final  DateTime sentAt;

/// Create a copy of SentVibe
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SentVibeCopyWith<_SentVibe> get copyWith => __$SentVibeCopyWithImpl<_SentVibe>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SentVibe&&(identical(other.id, id) || other.id == id)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.profileName, profileName) || other.profileName == profileName)&&(identical(other.context, context) || other.context == context)&&(identical(other.joinMeForOption, joinMeForOption) || other.joinMeForOption == joinMeForOption)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,profileId,profileName,context,joinMeForOption,sentAt);

@override
String toString() {
  return 'SentVibe(id: $id, profileId: $profileId, profileName: $profileName, context: $context, joinMeForOption: $joinMeForOption, sentAt: $sentAt)';
}


}

/// @nodoc
abstract mixin class _$SentVibeCopyWith<$Res> implements $SentVibeCopyWith<$Res> {
  factory _$SentVibeCopyWith(_SentVibe value, $Res Function(_SentVibe) _then) = __$SentVibeCopyWithImpl;
@override @useResult
$Res call({
 String id, String profileId, String profileName, VibeContext context, String? joinMeForOption, DateTime sentAt
});




}
/// @nodoc
class __$SentVibeCopyWithImpl<$Res>
    implements _$SentVibeCopyWith<$Res> {
  __$SentVibeCopyWithImpl(this._self, this._then);

  final _SentVibe _self;
  final $Res Function(_SentVibe) _then;

/// Create a copy of SentVibe
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? profileId = null,Object? profileName = null,Object? context = null,Object? joinMeForOption = freezed,Object? sentAt = null,}) {
  return _then(_SentVibe(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String,profileName: null == profileName ? _self.profileName : profileName // ignore: cast_nullable_to_non_nullable
as String,context: null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as VibeContext,joinMeForOption: freezed == joinMeForOption ? _self.joinMeForOption : joinMeForOption // ignore: cast_nullable_to_non_nullable
as String?,sentAt: null == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$SentInvite {

 String get id; String get profileId; String get profileName; InviteType get type; String? get note; DateTime get sentAt;
/// Create a copy of SentInvite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SentInviteCopyWith<SentInvite> get copyWith => _$SentInviteCopyWithImpl<SentInvite>(this as SentInvite, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SentInvite&&(identical(other.id, id) || other.id == id)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.profileName, profileName) || other.profileName == profileName)&&(identical(other.type, type) || other.type == type)&&(identical(other.note, note) || other.note == note)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,profileId,profileName,type,note,sentAt);

@override
String toString() {
  return 'SentInvite(id: $id, profileId: $profileId, profileName: $profileName, type: $type, note: $note, sentAt: $sentAt)';
}


}

/// @nodoc
abstract mixin class $SentInviteCopyWith<$Res>  {
  factory $SentInviteCopyWith(SentInvite value, $Res Function(SentInvite) _then) = _$SentInviteCopyWithImpl;
@useResult
$Res call({
 String id, String profileId, String profileName, InviteType type, String? note, DateTime sentAt
});




}
/// @nodoc
class _$SentInviteCopyWithImpl<$Res>
    implements $SentInviteCopyWith<$Res> {
  _$SentInviteCopyWithImpl(this._self, this._then);

  final SentInvite _self;
  final $Res Function(SentInvite) _then;

/// Create a copy of SentInvite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? profileId = null,Object? profileName = null,Object? type = null,Object? note = freezed,Object? sentAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String,profileName: null == profileName ? _self.profileName : profileName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as InviteType,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,sentAt: null == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SentInvite].
extension SentInvitePatterns on SentInvite {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SentInvite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SentInvite() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SentInvite value)  $default,){
final _that = this;
switch (_that) {
case _SentInvite():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SentInvite value)?  $default,){
final _that = this;
switch (_that) {
case _SentInvite() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String profileId,  String profileName,  InviteType type,  String? note,  DateTime sentAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SentInvite() when $default != null:
return $default(_that.id,_that.profileId,_that.profileName,_that.type,_that.note,_that.sentAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String profileId,  String profileName,  InviteType type,  String? note,  DateTime sentAt)  $default,) {final _that = this;
switch (_that) {
case _SentInvite():
return $default(_that.id,_that.profileId,_that.profileName,_that.type,_that.note,_that.sentAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String profileId,  String profileName,  InviteType type,  String? note,  DateTime sentAt)?  $default,) {final _that = this;
switch (_that) {
case _SentInvite() when $default != null:
return $default(_that.id,_that.profileId,_that.profileName,_that.type,_that.note,_that.sentAt);case _:
  return null;

}
}

}

/// @nodoc


class _SentInvite implements SentInvite {
  const _SentInvite({required this.id, required this.profileId, required this.profileName, required this.type, this.note, required this.sentAt});
  

@override final  String id;
@override final  String profileId;
@override final  String profileName;
@override final  InviteType type;
@override final  String? note;
@override final  DateTime sentAt;

/// Create a copy of SentInvite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SentInviteCopyWith<_SentInvite> get copyWith => __$SentInviteCopyWithImpl<_SentInvite>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SentInvite&&(identical(other.id, id) || other.id == id)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.profileName, profileName) || other.profileName == profileName)&&(identical(other.type, type) || other.type == type)&&(identical(other.note, note) || other.note == note)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,profileId,profileName,type,note,sentAt);

@override
String toString() {
  return 'SentInvite(id: $id, profileId: $profileId, profileName: $profileName, type: $type, note: $note, sentAt: $sentAt)';
}


}

/// @nodoc
abstract mixin class _$SentInviteCopyWith<$Res> implements $SentInviteCopyWith<$Res> {
  factory _$SentInviteCopyWith(_SentInvite value, $Res Function(_SentInvite) _then) = __$SentInviteCopyWithImpl;
@override @useResult
$Res call({
 String id, String profileId, String profileName, InviteType type, String? note, DateTime sentAt
});




}
/// @nodoc
class __$SentInviteCopyWithImpl<$Res>
    implements _$SentInviteCopyWith<$Res> {
  __$SentInviteCopyWithImpl(this._self, this._then);

  final _SentInvite _self;
  final $Res Function(_SentInvite) _then;

/// Create a copy of SentInvite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? profileId = null,Object? profileName = null,Object? type = null,Object? note = freezed,Object? sentAt = null,}) {
  return _then(_SentInvite(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String,profileName: null == profileName ? _self.profileName : profileName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as InviteType,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,sentAt: null == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
