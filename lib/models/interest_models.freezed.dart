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

/// @nodoc
mixin _$ReceivedVibe {

 String get id; DiscoveryProfile get from; VibeContext get context;/// For a Join-Me-For vibe: the option they vibed with.
 String? get joinMeForOption; InterestStatus get status;
/// Create a copy of ReceivedVibe
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceivedVibeCopyWith<ReceivedVibe> get copyWith => _$ReceivedVibeCopyWithImpl<ReceivedVibe>(this as ReceivedVibe, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceivedVibe&&(identical(other.id, id) || other.id == id)&&(identical(other.from, from) || other.from == from)&&(identical(other.context, context) || other.context == context)&&(identical(other.joinMeForOption, joinMeForOption) || other.joinMeForOption == joinMeForOption)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,from,context,joinMeForOption,status);

@override
String toString() {
  return 'ReceivedVibe(id: $id, from: $from, context: $context, joinMeForOption: $joinMeForOption, status: $status)';
}


}

/// @nodoc
abstract mixin class $ReceivedVibeCopyWith<$Res>  {
  factory $ReceivedVibeCopyWith(ReceivedVibe value, $Res Function(ReceivedVibe) _then) = _$ReceivedVibeCopyWithImpl;
@useResult
$Res call({
 String id, DiscoveryProfile from, VibeContext context, String? joinMeForOption, InterestStatus status
});


$DiscoveryProfileCopyWith<$Res> get from;

}
/// @nodoc
class _$ReceivedVibeCopyWithImpl<$Res>
    implements $ReceivedVibeCopyWith<$Res> {
  _$ReceivedVibeCopyWithImpl(this._self, this._then);

  final ReceivedVibe _self;
  final $Res Function(ReceivedVibe) _then;

/// Create a copy of ReceivedVibe
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? from = null,Object? context = null,Object? joinMeForOption = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DiscoveryProfile,context: null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as VibeContext,joinMeForOption: freezed == joinMeForOption ? _self.joinMeForOption : joinMeForOption // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InterestStatus,
  ));
}
/// Create a copy of ReceivedVibe
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiscoveryProfileCopyWith<$Res> get from {
  
  return $DiscoveryProfileCopyWith<$Res>(_self.from, (value) {
    return _then(_self.copyWith(from: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReceivedVibe].
extension ReceivedVibePatterns on ReceivedVibe {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceivedVibe value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceivedVibe() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceivedVibe value)  $default,){
final _that = this;
switch (_that) {
case _ReceivedVibe():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceivedVibe value)?  $default,){
final _that = this;
switch (_that) {
case _ReceivedVibe() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DiscoveryProfile from,  VibeContext context,  String? joinMeForOption,  InterestStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceivedVibe() when $default != null:
return $default(_that.id,_that.from,_that.context,_that.joinMeForOption,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DiscoveryProfile from,  VibeContext context,  String? joinMeForOption,  InterestStatus status)  $default,) {final _that = this;
switch (_that) {
case _ReceivedVibe():
return $default(_that.id,_that.from,_that.context,_that.joinMeForOption,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DiscoveryProfile from,  VibeContext context,  String? joinMeForOption,  InterestStatus status)?  $default,) {final _that = this;
switch (_that) {
case _ReceivedVibe() when $default != null:
return $default(_that.id,_that.from,_that.context,_that.joinMeForOption,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _ReceivedVibe implements ReceivedVibe {
  const _ReceivedVibe({required this.id, required this.from, required this.context, this.joinMeForOption, this.status = InterestStatus.pending});
  

@override final  String id;
@override final  DiscoveryProfile from;
@override final  VibeContext context;
/// For a Join-Me-For vibe: the option they vibed with.
@override final  String? joinMeForOption;
@override@JsonKey() final  InterestStatus status;

/// Create a copy of ReceivedVibe
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceivedVibeCopyWith<_ReceivedVibe> get copyWith => __$ReceivedVibeCopyWithImpl<_ReceivedVibe>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceivedVibe&&(identical(other.id, id) || other.id == id)&&(identical(other.from, from) || other.from == from)&&(identical(other.context, context) || other.context == context)&&(identical(other.joinMeForOption, joinMeForOption) || other.joinMeForOption == joinMeForOption)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,from,context,joinMeForOption,status);

@override
String toString() {
  return 'ReceivedVibe(id: $id, from: $from, context: $context, joinMeForOption: $joinMeForOption, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ReceivedVibeCopyWith<$Res> implements $ReceivedVibeCopyWith<$Res> {
  factory _$ReceivedVibeCopyWith(_ReceivedVibe value, $Res Function(_ReceivedVibe) _then) = __$ReceivedVibeCopyWithImpl;
@override @useResult
$Res call({
 String id, DiscoveryProfile from, VibeContext context, String? joinMeForOption, InterestStatus status
});


@override $DiscoveryProfileCopyWith<$Res> get from;

}
/// @nodoc
class __$ReceivedVibeCopyWithImpl<$Res>
    implements _$ReceivedVibeCopyWith<$Res> {
  __$ReceivedVibeCopyWithImpl(this._self, this._then);

  final _ReceivedVibe _self;
  final $Res Function(_ReceivedVibe) _then;

/// Create a copy of ReceivedVibe
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? from = null,Object? context = null,Object? joinMeForOption = freezed,Object? status = null,}) {
  return _then(_ReceivedVibe(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DiscoveryProfile,context: null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as VibeContext,joinMeForOption: freezed == joinMeForOption ? _self.joinMeForOption : joinMeForOption // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InterestStatus,
  ));
}

/// Create a copy of ReceivedVibe
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiscoveryProfileCopyWith<$Res> get from {
  
  return $DiscoveryProfileCopyWith<$Res>(_self.from, (value) {
    return _then(_self.copyWith(from: value));
  });
}
}

/// @nodoc
mixin _$ReceivedInvite {

 String get id; DiscoveryProfile get from; InviteType get type; String? get message; InterestStatus get status;
/// Create a copy of ReceivedInvite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceivedInviteCopyWith<ReceivedInvite> get copyWith => _$ReceivedInviteCopyWithImpl<ReceivedInvite>(this as ReceivedInvite, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceivedInvite&&(identical(other.id, id) || other.id == id)&&(identical(other.from, from) || other.from == from)&&(identical(other.type, type) || other.type == type)&&(identical(other.message, message) || other.message == message)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,from,type,message,status);

@override
String toString() {
  return 'ReceivedInvite(id: $id, from: $from, type: $type, message: $message, status: $status)';
}


}

/// @nodoc
abstract mixin class $ReceivedInviteCopyWith<$Res>  {
  factory $ReceivedInviteCopyWith(ReceivedInvite value, $Res Function(ReceivedInvite) _then) = _$ReceivedInviteCopyWithImpl;
@useResult
$Res call({
 String id, DiscoveryProfile from, InviteType type, String? message, InterestStatus status
});


$DiscoveryProfileCopyWith<$Res> get from;

}
/// @nodoc
class _$ReceivedInviteCopyWithImpl<$Res>
    implements $ReceivedInviteCopyWith<$Res> {
  _$ReceivedInviteCopyWithImpl(this._self, this._then);

  final ReceivedInvite _self;
  final $Res Function(ReceivedInvite) _then;

/// Create a copy of ReceivedInvite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? from = null,Object? type = null,Object? message = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DiscoveryProfile,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as InviteType,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InterestStatus,
  ));
}
/// Create a copy of ReceivedInvite
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiscoveryProfileCopyWith<$Res> get from {
  
  return $DiscoveryProfileCopyWith<$Res>(_self.from, (value) {
    return _then(_self.copyWith(from: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReceivedInvite].
extension ReceivedInvitePatterns on ReceivedInvite {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceivedInvite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceivedInvite() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceivedInvite value)  $default,){
final _that = this;
switch (_that) {
case _ReceivedInvite():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceivedInvite value)?  $default,){
final _that = this;
switch (_that) {
case _ReceivedInvite() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DiscoveryProfile from,  InviteType type,  String? message,  InterestStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceivedInvite() when $default != null:
return $default(_that.id,_that.from,_that.type,_that.message,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DiscoveryProfile from,  InviteType type,  String? message,  InterestStatus status)  $default,) {final _that = this;
switch (_that) {
case _ReceivedInvite():
return $default(_that.id,_that.from,_that.type,_that.message,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DiscoveryProfile from,  InviteType type,  String? message,  InterestStatus status)?  $default,) {final _that = this;
switch (_that) {
case _ReceivedInvite() when $default != null:
return $default(_that.id,_that.from,_that.type,_that.message,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _ReceivedInvite implements ReceivedInvite {
  const _ReceivedInvite({required this.id, required this.from, required this.type, this.message, this.status = InterestStatus.pending});
  

@override final  String id;
@override final  DiscoveryProfile from;
@override final  InviteType type;
@override final  String? message;
@override@JsonKey() final  InterestStatus status;

/// Create a copy of ReceivedInvite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceivedInviteCopyWith<_ReceivedInvite> get copyWith => __$ReceivedInviteCopyWithImpl<_ReceivedInvite>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceivedInvite&&(identical(other.id, id) || other.id == id)&&(identical(other.from, from) || other.from == from)&&(identical(other.type, type) || other.type == type)&&(identical(other.message, message) || other.message == message)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,from,type,message,status);

@override
String toString() {
  return 'ReceivedInvite(id: $id, from: $from, type: $type, message: $message, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ReceivedInviteCopyWith<$Res> implements $ReceivedInviteCopyWith<$Res> {
  factory _$ReceivedInviteCopyWith(_ReceivedInvite value, $Res Function(_ReceivedInvite) _then) = __$ReceivedInviteCopyWithImpl;
@override @useResult
$Res call({
 String id, DiscoveryProfile from, InviteType type, String? message, InterestStatus status
});


@override $DiscoveryProfileCopyWith<$Res> get from;

}
/// @nodoc
class __$ReceivedInviteCopyWithImpl<$Res>
    implements _$ReceivedInviteCopyWith<$Res> {
  __$ReceivedInviteCopyWithImpl(this._self, this._then);

  final _ReceivedInvite _self;
  final $Res Function(_ReceivedInvite) _then;

/// Create a copy of ReceivedInvite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? from = null,Object? type = null,Object? message = freezed,Object? status = null,}) {
  return _then(_ReceivedInvite(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DiscoveryProfile,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as InviteType,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InterestStatus,
  ));
}

/// Create a copy of ReceivedInvite
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiscoveryProfileCopyWith<$Res> get from {
  
  return $DiscoveryProfileCopyWith<$Res>(_self.from, (value) {
    return _then(_self.copyWith(from: value));
  });
}
}

// dart format on
