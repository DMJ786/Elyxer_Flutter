// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verification_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PhoneInputData {

 String get countryCode; String get phoneNumber;
/// Create a copy of PhoneInputData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhoneInputDataCopyWith<PhoneInputData> get copyWith => _$PhoneInputDataCopyWithImpl<PhoneInputData>(this as PhoneInputData, _$identity);

  /// Serializes this PhoneInputData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhoneInputData&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,countryCode,phoneNumber);

@override
String toString() {
  return 'PhoneInputData(countryCode: $countryCode, phoneNumber: $phoneNumber)';
}


}

/// @nodoc
abstract mixin class $PhoneInputDataCopyWith<$Res>  {
  factory $PhoneInputDataCopyWith(PhoneInputData value, $Res Function(PhoneInputData) _then) = _$PhoneInputDataCopyWithImpl;
@useResult
$Res call({
 String countryCode, String phoneNumber
});




}
/// @nodoc
class _$PhoneInputDataCopyWithImpl<$Res>
    implements $PhoneInputDataCopyWith<$Res> {
  _$PhoneInputDataCopyWithImpl(this._self, this._then);

  final PhoneInputData _self;
  final $Res Function(PhoneInputData) _then;

/// Create a copy of PhoneInputData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? countryCode = null,Object? phoneNumber = null,}) {
  return _then(_self.copyWith(
countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PhoneInputData].
extension PhoneInputDataPatterns on PhoneInputData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhoneInputData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhoneInputData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhoneInputData value)  $default,){
final _that = this;
switch (_that) {
case _PhoneInputData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhoneInputData value)?  $default,){
final _that = this;
switch (_that) {
case _PhoneInputData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String countryCode,  String phoneNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhoneInputData() when $default != null:
return $default(_that.countryCode,_that.phoneNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String countryCode,  String phoneNumber)  $default,) {final _that = this;
switch (_that) {
case _PhoneInputData():
return $default(_that.countryCode,_that.phoneNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String countryCode,  String phoneNumber)?  $default,) {final _that = this;
switch (_that) {
case _PhoneInputData() when $default != null:
return $default(_that.countryCode,_that.phoneNumber);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PhoneInputData implements PhoneInputData {
  const _PhoneInputData({required this.countryCode, required this.phoneNumber});
  factory _PhoneInputData.fromJson(Map<String, dynamic> json) => _$PhoneInputDataFromJson(json);

@override final  String countryCode;
@override final  String phoneNumber;

/// Create a copy of PhoneInputData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhoneInputDataCopyWith<_PhoneInputData> get copyWith => __$PhoneInputDataCopyWithImpl<_PhoneInputData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhoneInputDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhoneInputData&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,countryCode,phoneNumber);

@override
String toString() {
  return 'PhoneInputData(countryCode: $countryCode, phoneNumber: $phoneNumber)';
}


}

/// @nodoc
abstract mixin class _$PhoneInputDataCopyWith<$Res> implements $PhoneInputDataCopyWith<$Res> {
  factory _$PhoneInputDataCopyWith(_PhoneInputData value, $Res Function(_PhoneInputData) _then) = __$PhoneInputDataCopyWithImpl;
@override @useResult
$Res call({
 String countryCode, String phoneNumber
});




}
/// @nodoc
class __$PhoneInputDataCopyWithImpl<$Res>
    implements _$PhoneInputDataCopyWith<$Res> {
  __$PhoneInputDataCopyWithImpl(this._self, this._then);

  final _PhoneInputData _self;
  final $Res Function(_PhoneInputData) _then;

/// Create a copy of PhoneInputData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? countryCode = null,Object? phoneNumber = null,}) {
  return _then(_PhoneInputData(
countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$OTPData {

 String get code; DateTime? get expiresAt;
/// Create a copy of OTPData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OTPDataCopyWith<OTPData> get copyWith => _$OTPDataCopyWithImpl<OTPData>(this as OTPData, _$identity);

  /// Serializes this OTPData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OTPData&&(identical(other.code, code) || other.code == code)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,expiresAt);

@override
String toString() {
  return 'OTPData(code: $code, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $OTPDataCopyWith<$Res>  {
  factory $OTPDataCopyWith(OTPData value, $Res Function(OTPData) _then) = _$OTPDataCopyWithImpl;
@useResult
$Res call({
 String code, DateTime? expiresAt
});




}
/// @nodoc
class _$OTPDataCopyWithImpl<$Res>
    implements $OTPDataCopyWith<$Res> {
  _$OTPDataCopyWithImpl(this._self, this._then);

  final OTPData _self;
  final $Res Function(OTPData) _then;

/// Create a copy of OTPData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? expiresAt = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [OTPData].
extension OTPDataPatterns on OTPData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OTPData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OTPData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OTPData value)  $default,){
final _that = this;
switch (_that) {
case _OTPData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OTPData value)?  $default,){
final _that = this;
switch (_that) {
case _OTPData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  DateTime? expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OTPData() when $default != null:
return $default(_that.code,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  DateTime? expiresAt)  $default,) {final _that = this;
switch (_that) {
case _OTPData():
return $default(_that.code,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  DateTime? expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _OTPData() when $default != null:
return $default(_that.code,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OTPData implements OTPData {
  const _OTPData({required this.code, this.expiresAt});
  factory _OTPData.fromJson(Map<String, dynamic> json) => _$OTPDataFromJson(json);

@override final  String code;
@override final  DateTime? expiresAt;

/// Create a copy of OTPData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OTPDataCopyWith<_OTPData> get copyWith => __$OTPDataCopyWithImpl<_OTPData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OTPDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OTPData&&(identical(other.code, code) || other.code == code)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,expiresAt);

@override
String toString() {
  return 'OTPData(code: $code, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$OTPDataCopyWith<$Res> implements $OTPDataCopyWith<$Res> {
  factory _$OTPDataCopyWith(_OTPData value, $Res Function(_OTPData) _then) = __$OTPDataCopyWithImpl;
@override @useResult
$Res call({
 String code, DateTime? expiresAt
});




}
/// @nodoc
class __$OTPDataCopyWithImpl<$Res>
    implements _$OTPDataCopyWith<$Res> {
  __$OTPDataCopyWithImpl(this._self, this._then);

  final _OTPData _self;
  final $Res Function(_OTPData) _then;

/// Create a copy of OTPData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? expiresAt = freezed,}) {
  return _then(_OTPData(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$UsernameData {

 String get firstName; String? get lastName;
/// Create a copy of UsernameData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsernameDataCopyWith<UsernameData> get copyWith => _$UsernameDataCopyWithImpl<UsernameData>(this as UsernameData, _$identity);

  /// Serializes this UsernameData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsernameData&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName);

@override
String toString() {
  return 'UsernameData(firstName: $firstName, lastName: $lastName)';
}


}

/// @nodoc
abstract mixin class $UsernameDataCopyWith<$Res>  {
  factory $UsernameDataCopyWith(UsernameData value, $Res Function(UsernameData) _then) = _$UsernameDataCopyWithImpl;
@useResult
$Res call({
 String firstName, String? lastName
});




}
/// @nodoc
class _$UsernameDataCopyWithImpl<$Res>
    implements $UsernameDataCopyWith<$Res> {
  _$UsernameDataCopyWithImpl(this._self, this._then);

  final UsernameData _self;
  final $Res Function(UsernameData) _then;

/// Create a copy of UsernameData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? firstName = null,Object? lastName = freezed,}) {
  return _then(_self.copyWith(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UsernameData].
extension UsernameDataPatterns on UsernameData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsernameData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsernameData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsernameData value)  $default,){
final _that = this;
switch (_that) {
case _UsernameData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsernameData value)?  $default,){
final _that = this;
switch (_that) {
case _UsernameData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String firstName,  String? lastName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsernameData() when $default != null:
return $default(_that.firstName,_that.lastName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String firstName,  String? lastName)  $default,) {final _that = this;
switch (_that) {
case _UsernameData():
return $default(_that.firstName,_that.lastName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String firstName,  String? lastName)?  $default,) {final _that = this;
switch (_that) {
case _UsernameData() when $default != null:
return $default(_that.firstName,_that.lastName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UsernameData implements UsernameData {
  const _UsernameData({required this.firstName, this.lastName});
  factory _UsernameData.fromJson(Map<String, dynamic> json) => _$UsernameDataFromJson(json);

@override final  String firstName;
@override final  String? lastName;

/// Create a copy of UsernameData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsernameDataCopyWith<_UsernameData> get copyWith => __$UsernameDataCopyWithImpl<_UsernameData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UsernameDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsernameData&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName);

@override
String toString() {
  return 'UsernameData(firstName: $firstName, lastName: $lastName)';
}


}

/// @nodoc
abstract mixin class _$UsernameDataCopyWith<$Res> implements $UsernameDataCopyWith<$Res> {
  factory _$UsernameDataCopyWith(_UsernameData value, $Res Function(_UsernameData) _then) = __$UsernameDataCopyWithImpl;
@override @useResult
$Res call({
 String firstName, String? lastName
});




}
/// @nodoc
class __$UsernameDataCopyWithImpl<$Res>
    implements _$UsernameDataCopyWith<$Res> {
  __$UsernameDataCopyWithImpl(this._self, this._then);

  final _UsernameData _self;
  final $Res Function(_UsernameData) _then;

/// Create a copy of UsernameData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firstName = null,Object? lastName = freezed,}) {
  return _then(_UsernameData(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$EmailInputData {

 String get email; bool get enableNotifications;
/// Create a copy of EmailInputData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmailInputDataCopyWith<EmailInputData> get copyWith => _$EmailInputDataCopyWithImpl<EmailInputData>(this as EmailInputData, _$identity);

  /// Serializes this EmailInputData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmailInputData&&(identical(other.email, email) || other.email == email)&&(identical(other.enableNotifications, enableNotifications) || other.enableNotifications == enableNotifications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,enableNotifications);

@override
String toString() {
  return 'EmailInputData(email: $email, enableNotifications: $enableNotifications)';
}


}

/// @nodoc
abstract mixin class $EmailInputDataCopyWith<$Res>  {
  factory $EmailInputDataCopyWith(EmailInputData value, $Res Function(EmailInputData) _then) = _$EmailInputDataCopyWithImpl;
@useResult
$Res call({
 String email, bool enableNotifications
});




}
/// @nodoc
class _$EmailInputDataCopyWithImpl<$Res>
    implements $EmailInputDataCopyWith<$Res> {
  _$EmailInputDataCopyWithImpl(this._self, this._then);

  final EmailInputData _self;
  final $Res Function(EmailInputData) _then;

/// Create a copy of EmailInputData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? enableNotifications = null,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,enableNotifications: null == enableNotifications ? _self.enableNotifications : enableNotifications // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EmailInputData].
extension EmailInputDataPatterns on EmailInputData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmailInputData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmailInputData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmailInputData value)  $default,){
final _that = this;
switch (_that) {
case _EmailInputData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmailInputData value)?  $default,){
final _that = this;
switch (_that) {
case _EmailInputData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  bool enableNotifications)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmailInputData() when $default != null:
return $default(_that.email,_that.enableNotifications);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  bool enableNotifications)  $default,) {final _that = this;
switch (_that) {
case _EmailInputData():
return $default(_that.email,_that.enableNotifications);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  bool enableNotifications)?  $default,) {final _that = this;
switch (_that) {
case _EmailInputData() when $default != null:
return $default(_that.email,_that.enableNotifications);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmailInputData implements EmailInputData {
  const _EmailInputData({required this.email, this.enableNotifications = false});
  factory _EmailInputData.fromJson(Map<String, dynamic> json) => _$EmailInputDataFromJson(json);

@override final  String email;
@override@JsonKey() final  bool enableNotifications;

/// Create a copy of EmailInputData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmailInputDataCopyWith<_EmailInputData> get copyWith => __$EmailInputDataCopyWithImpl<_EmailInputData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmailInputDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmailInputData&&(identical(other.email, email) || other.email == email)&&(identical(other.enableNotifications, enableNotifications) || other.enableNotifications == enableNotifications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,enableNotifications);

@override
String toString() {
  return 'EmailInputData(email: $email, enableNotifications: $enableNotifications)';
}


}

/// @nodoc
abstract mixin class _$EmailInputDataCopyWith<$Res> implements $EmailInputDataCopyWith<$Res> {
  factory _$EmailInputDataCopyWith(_EmailInputData value, $Res Function(_EmailInputData) _then) = __$EmailInputDataCopyWithImpl;
@override @useResult
$Res call({
 String email, bool enableNotifications
});




}
/// @nodoc
class __$EmailInputDataCopyWithImpl<$Res>
    implements _$EmailInputDataCopyWith<$Res> {
  __$EmailInputDataCopyWithImpl(this._self, this._then);

  final _EmailInputData _self;
  final $Res Function(_EmailInputData) _then;

/// Create a copy of EmailInputData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? enableNotifications = null,}) {
  return _then(_EmailInputData(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,enableNotifications: null == enableNotifications ? _self.enableNotifications : enableNotifications // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$VerificationData {

 PhoneInputData get phone; bool get phoneVerified; UsernameData get username; EmailInputData? get email; bool get emailVerified; bool get emailSkipped;
/// Create a copy of VerificationData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerificationDataCopyWith<VerificationData> get copyWith => _$VerificationDataCopyWithImpl<VerificationData>(this as VerificationData, _$identity);

  /// Serializes this VerificationData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerificationData&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.phoneVerified, phoneVerified) || other.phoneVerified == phoneVerified)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.emailSkipped, emailSkipped) || other.emailSkipped == emailSkipped));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phone,phoneVerified,username,email,emailVerified,emailSkipped);

@override
String toString() {
  return 'VerificationData(phone: $phone, phoneVerified: $phoneVerified, username: $username, email: $email, emailVerified: $emailVerified, emailSkipped: $emailSkipped)';
}


}

/// @nodoc
abstract mixin class $VerificationDataCopyWith<$Res>  {
  factory $VerificationDataCopyWith(VerificationData value, $Res Function(VerificationData) _then) = _$VerificationDataCopyWithImpl;
@useResult
$Res call({
 PhoneInputData phone, bool phoneVerified, UsernameData username, EmailInputData? email, bool emailVerified, bool emailSkipped
});


$PhoneInputDataCopyWith<$Res> get phone;$UsernameDataCopyWith<$Res> get username;$EmailInputDataCopyWith<$Res>? get email;

}
/// @nodoc
class _$VerificationDataCopyWithImpl<$Res>
    implements $VerificationDataCopyWith<$Res> {
  _$VerificationDataCopyWithImpl(this._self, this._then);

  final VerificationData _self;
  final $Res Function(VerificationData) _then;

/// Create a copy of VerificationData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phone = null,Object? phoneVerified = null,Object? username = null,Object? email = freezed,Object? emailVerified = null,Object? emailSkipped = null,}) {
  return _then(_self.copyWith(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as PhoneInputData,phoneVerified: null == phoneVerified ? _self.phoneVerified : phoneVerified // ignore: cast_nullable_to_non_nullable
as bool,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as UsernameData,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as EmailInputData?,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,emailSkipped: null == emailSkipped ? _self.emailSkipped : emailSkipped // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of VerificationData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PhoneInputDataCopyWith<$Res> get phone {
  
  return $PhoneInputDataCopyWith<$Res>(_self.phone, (value) {
    return _then(_self.copyWith(phone: value));
  });
}/// Create a copy of VerificationData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UsernameDataCopyWith<$Res> get username {
  
  return $UsernameDataCopyWith<$Res>(_self.username, (value) {
    return _then(_self.copyWith(username: value));
  });
}/// Create a copy of VerificationData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmailInputDataCopyWith<$Res>? get email {
    if (_self.email == null) {
    return null;
  }

  return $EmailInputDataCopyWith<$Res>(_self.email!, (value) {
    return _then(_self.copyWith(email: value));
  });
}
}


/// Adds pattern-matching-related methods to [VerificationData].
extension VerificationDataPatterns on VerificationData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerificationData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerificationData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerificationData value)  $default,){
final _that = this;
switch (_that) {
case _VerificationData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerificationData value)?  $default,){
final _that = this;
switch (_that) {
case _VerificationData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PhoneInputData phone,  bool phoneVerified,  UsernameData username,  EmailInputData? email,  bool emailVerified,  bool emailSkipped)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerificationData() when $default != null:
return $default(_that.phone,_that.phoneVerified,_that.username,_that.email,_that.emailVerified,_that.emailSkipped);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PhoneInputData phone,  bool phoneVerified,  UsernameData username,  EmailInputData? email,  bool emailVerified,  bool emailSkipped)  $default,) {final _that = this;
switch (_that) {
case _VerificationData():
return $default(_that.phone,_that.phoneVerified,_that.username,_that.email,_that.emailVerified,_that.emailSkipped);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PhoneInputData phone,  bool phoneVerified,  UsernameData username,  EmailInputData? email,  bool emailVerified,  bool emailSkipped)?  $default,) {final _that = this;
switch (_that) {
case _VerificationData() when $default != null:
return $default(_that.phone,_that.phoneVerified,_that.username,_that.email,_that.emailVerified,_that.emailSkipped);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VerificationData implements VerificationData {
  const _VerificationData({required this.phone, this.phoneVerified = false, required this.username, this.email, this.emailVerified = false, this.emailSkipped = false});
  factory _VerificationData.fromJson(Map<String, dynamic> json) => _$VerificationDataFromJson(json);

@override final  PhoneInputData phone;
@override@JsonKey() final  bool phoneVerified;
@override final  UsernameData username;
@override final  EmailInputData? email;
@override@JsonKey() final  bool emailVerified;
@override@JsonKey() final  bool emailSkipped;

/// Create a copy of VerificationData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerificationDataCopyWith<_VerificationData> get copyWith => __$VerificationDataCopyWithImpl<_VerificationData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VerificationDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerificationData&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.phoneVerified, phoneVerified) || other.phoneVerified == phoneVerified)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.emailSkipped, emailSkipped) || other.emailSkipped == emailSkipped));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phone,phoneVerified,username,email,emailVerified,emailSkipped);

@override
String toString() {
  return 'VerificationData(phone: $phone, phoneVerified: $phoneVerified, username: $username, email: $email, emailVerified: $emailVerified, emailSkipped: $emailSkipped)';
}


}

/// @nodoc
abstract mixin class _$VerificationDataCopyWith<$Res> implements $VerificationDataCopyWith<$Res> {
  factory _$VerificationDataCopyWith(_VerificationData value, $Res Function(_VerificationData) _then) = __$VerificationDataCopyWithImpl;
@override @useResult
$Res call({
 PhoneInputData phone, bool phoneVerified, UsernameData username, EmailInputData? email, bool emailVerified, bool emailSkipped
});


@override $PhoneInputDataCopyWith<$Res> get phone;@override $UsernameDataCopyWith<$Res> get username;@override $EmailInputDataCopyWith<$Res>? get email;

}
/// @nodoc
class __$VerificationDataCopyWithImpl<$Res>
    implements _$VerificationDataCopyWith<$Res> {
  __$VerificationDataCopyWithImpl(this._self, this._then);

  final _VerificationData _self;
  final $Res Function(_VerificationData) _then;

/// Create a copy of VerificationData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phone = null,Object? phoneVerified = null,Object? username = null,Object? email = freezed,Object? emailVerified = null,Object? emailSkipped = null,}) {
  return _then(_VerificationData(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as PhoneInputData,phoneVerified: null == phoneVerified ? _self.phoneVerified : phoneVerified // ignore: cast_nullable_to_non_nullable
as bool,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as UsernameData,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as EmailInputData?,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,emailSkipped: null == emailSkipped ? _self.emailSkipped : emailSkipped // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of VerificationData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PhoneInputDataCopyWith<$Res> get phone {
  
  return $PhoneInputDataCopyWith<$Res>(_self.phone, (value) {
    return _then(_self.copyWith(phone: value));
  });
}/// Create a copy of VerificationData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UsernameDataCopyWith<$Res> get username {
  
  return $UsernameDataCopyWith<$Res>(_self.username, (value) {
    return _then(_self.copyWith(username: value));
  });
}/// Create a copy of VerificationData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmailInputDataCopyWith<$Res>? get email {
    if (_self.email == null) {
    return null;
  }

  return $EmailInputDataCopyWith<$Res>(_self.email!, (value) {
    return _then(_self.copyWith(email: value));
  });
}
}


/// @nodoc
mixin _$SendOTPResponse {

 bool get success; String get expiresAt; String? get message;
/// Create a copy of SendOTPResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendOTPResponseCopyWith<SendOTPResponse> get copyWith => _$SendOTPResponseCopyWithImpl<SendOTPResponse>(this as SendOTPResponse, _$identity);

  /// Serializes this SendOTPResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendOTPResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,expiresAt,message);

@override
String toString() {
  return 'SendOTPResponse(success: $success, expiresAt: $expiresAt, message: $message)';
}


}

/// @nodoc
abstract mixin class $SendOTPResponseCopyWith<$Res>  {
  factory $SendOTPResponseCopyWith(SendOTPResponse value, $Res Function(SendOTPResponse) _then) = _$SendOTPResponseCopyWithImpl;
@useResult
$Res call({
 bool success, String expiresAt, String? message
});




}
/// @nodoc
class _$SendOTPResponseCopyWithImpl<$Res>
    implements $SendOTPResponseCopyWith<$Res> {
  _$SendOTPResponseCopyWithImpl(this._self, this._then);

  final SendOTPResponse _self;
  final $Res Function(SendOTPResponse) _then;

/// Create a copy of SendOTPResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? expiresAt = null,Object? message = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SendOTPResponse].
extension SendOTPResponsePatterns on SendOTPResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SendOTPResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SendOTPResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SendOTPResponse value)  $default,){
final _that = this;
switch (_that) {
case _SendOTPResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SendOTPResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SendOTPResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String expiresAt,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SendOTPResponse() when $default != null:
return $default(_that.success,_that.expiresAt,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String expiresAt,  String? message)  $default,) {final _that = this;
switch (_that) {
case _SendOTPResponse():
return $default(_that.success,_that.expiresAt,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String expiresAt,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _SendOTPResponse() when $default != null:
return $default(_that.success,_that.expiresAt,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SendOTPResponse implements SendOTPResponse {
  const _SendOTPResponse({required this.success, required this.expiresAt, this.message});
  factory _SendOTPResponse.fromJson(Map<String, dynamic> json) => _$SendOTPResponseFromJson(json);

@override final  bool success;
@override final  String expiresAt;
@override final  String? message;

/// Create a copy of SendOTPResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendOTPResponseCopyWith<_SendOTPResponse> get copyWith => __$SendOTPResponseCopyWithImpl<_SendOTPResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SendOTPResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendOTPResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,expiresAt,message);

@override
String toString() {
  return 'SendOTPResponse(success: $success, expiresAt: $expiresAt, message: $message)';
}


}

/// @nodoc
abstract mixin class _$SendOTPResponseCopyWith<$Res> implements $SendOTPResponseCopyWith<$Res> {
  factory _$SendOTPResponseCopyWith(_SendOTPResponse value, $Res Function(_SendOTPResponse) _then) = __$SendOTPResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, String expiresAt, String? message
});




}
/// @nodoc
class __$SendOTPResponseCopyWithImpl<$Res>
    implements _$SendOTPResponseCopyWith<$Res> {
  __$SendOTPResponseCopyWithImpl(this._self, this._then);

  final _SendOTPResponse _self;
  final $Res Function(_SendOTPResponse) _then;

/// Create a copy of SendOTPResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? expiresAt = null,Object? message = freezed,}) {
  return _then(_SendOTPResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$VerifyOTPResponse {

 bool get success; String? get token; String? get message;
/// Create a copy of VerifyOTPResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerifyOTPResponseCopyWith<VerifyOTPResponse> get copyWith => _$VerifyOTPResponseCopyWithImpl<VerifyOTPResponse>(this as VerifyOTPResponse, _$identity);

  /// Serializes this VerifyOTPResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifyOTPResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.token, token) || other.token == token)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,token,message);

@override
String toString() {
  return 'VerifyOTPResponse(success: $success, token: $token, message: $message)';
}


}

/// @nodoc
abstract mixin class $VerifyOTPResponseCopyWith<$Res>  {
  factory $VerifyOTPResponseCopyWith(VerifyOTPResponse value, $Res Function(VerifyOTPResponse) _then) = _$VerifyOTPResponseCopyWithImpl;
@useResult
$Res call({
 bool success, String? token, String? message
});




}
/// @nodoc
class _$VerifyOTPResponseCopyWithImpl<$Res>
    implements $VerifyOTPResponseCopyWith<$Res> {
  _$VerifyOTPResponseCopyWithImpl(this._self, this._then);

  final VerifyOTPResponse _self;
  final $Res Function(VerifyOTPResponse) _then;

/// Create a copy of VerifyOTPResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? token = freezed,Object? message = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VerifyOTPResponse].
extension VerifyOTPResponsePatterns on VerifyOTPResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerifyOTPResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerifyOTPResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerifyOTPResponse value)  $default,){
final _that = this;
switch (_that) {
case _VerifyOTPResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerifyOTPResponse value)?  $default,){
final _that = this;
switch (_that) {
case _VerifyOTPResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String? token,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerifyOTPResponse() when $default != null:
return $default(_that.success,_that.token,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String? token,  String? message)  $default,) {final _that = this;
switch (_that) {
case _VerifyOTPResponse():
return $default(_that.success,_that.token,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String? token,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _VerifyOTPResponse() when $default != null:
return $default(_that.success,_that.token,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VerifyOTPResponse implements VerifyOTPResponse {
  const _VerifyOTPResponse({required this.success, this.token, this.message});
  factory _VerifyOTPResponse.fromJson(Map<String, dynamic> json) => _$VerifyOTPResponseFromJson(json);

@override final  bool success;
@override final  String? token;
@override final  String? message;

/// Create a copy of VerifyOTPResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerifyOTPResponseCopyWith<_VerifyOTPResponse> get copyWith => __$VerifyOTPResponseCopyWithImpl<_VerifyOTPResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VerifyOTPResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerifyOTPResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.token, token) || other.token == token)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,token,message);

@override
String toString() {
  return 'VerifyOTPResponse(success: $success, token: $token, message: $message)';
}


}

/// @nodoc
abstract mixin class _$VerifyOTPResponseCopyWith<$Res> implements $VerifyOTPResponseCopyWith<$Res> {
  factory _$VerifyOTPResponseCopyWith(_VerifyOTPResponse value, $Res Function(_VerifyOTPResponse) _then) = __$VerifyOTPResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, String? token, String? message
});




}
/// @nodoc
class __$VerifyOTPResponseCopyWithImpl<$Res>
    implements _$VerifyOTPResponseCopyWith<$Res> {
  __$VerifyOTPResponseCopyWithImpl(this._self, this._then);

  final _VerifyOTPResponse _self;
  final $Res Function(_VerifyOTPResponse) _then;

/// Create a copy of VerifyOTPResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? token = freezed,Object? message = freezed,}) {
  return _then(_VerifyOTPResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ProgressStep {

 String get id; StepIcon get icon; StepStatus get status;
/// Create a copy of ProgressStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressStepCopyWith<ProgressStep> get copyWith => _$ProgressStepCopyWithImpl<ProgressStep>(this as ProgressStep, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgressStep&&(identical(other.id, id) || other.id == id)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,icon,status);

@override
String toString() {
  return 'ProgressStep(id: $id, icon: $icon, status: $status)';
}


}

/// @nodoc
abstract mixin class $ProgressStepCopyWith<$Res>  {
  factory $ProgressStepCopyWith(ProgressStep value, $Res Function(ProgressStep) _then) = _$ProgressStepCopyWithImpl;
@useResult
$Res call({
 String id, StepIcon icon, StepStatus status
});




}
/// @nodoc
class _$ProgressStepCopyWithImpl<$Res>
    implements $ProgressStepCopyWith<$Res> {
  _$ProgressStepCopyWithImpl(this._self, this._then);

  final ProgressStep _self;
  final $Res Function(ProgressStep) _then;

/// Create a copy of ProgressStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? icon = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as StepIcon,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StepStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [ProgressStep].
extension ProgressStepPatterns on ProgressStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgressStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgressStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgressStep value)  $default,){
final _that = this;
switch (_that) {
case _ProgressStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgressStep value)?  $default,){
final _that = this;
switch (_that) {
case _ProgressStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  StepIcon icon,  StepStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgressStep() when $default != null:
return $default(_that.id,_that.icon,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  StepIcon icon,  StepStatus status)  $default,) {final _that = this;
switch (_that) {
case _ProgressStep():
return $default(_that.id,_that.icon,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  StepIcon icon,  StepStatus status)?  $default,) {final _that = this;
switch (_that) {
case _ProgressStep() when $default != null:
return $default(_that.id,_that.icon,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _ProgressStep implements ProgressStep {
  const _ProgressStep({required this.id, required this.icon, required this.status});
  

@override final  String id;
@override final  StepIcon icon;
@override final  StepStatus status;

/// Create a copy of ProgressStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressStepCopyWith<_ProgressStep> get copyWith => __$ProgressStepCopyWithImpl<_ProgressStep>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgressStep&&(identical(other.id, id) || other.id == id)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,icon,status);

@override
String toString() {
  return 'ProgressStep(id: $id, icon: $icon, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ProgressStepCopyWith<$Res> implements $ProgressStepCopyWith<$Res> {
  factory _$ProgressStepCopyWith(_ProgressStep value, $Res Function(_ProgressStep) _then) = __$ProgressStepCopyWithImpl;
@override @useResult
$Res call({
 String id, StepIcon icon, StepStatus status
});




}
/// @nodoc
class __$ProgressStepCopyWithImpl<$Res>
    implements _$ProgressStepCopyWith<$Res> {
  __$ProgressStepCopyWithImpl(this._self, this._then);

  final _ProgressStep _self;
  final $Res Function(_ProgressStep) _then;

/// Create a copy of ProgressStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? icon = null,Object? status = null,}) {
  return _then(_ProgressStep(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as StepIcon,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StepStatus,
  ));
}


}

/// @nodoc
mixin _$OTPTimerState {

 int get timeLeft; bool get isExpired; bool get canResend;
/// Create a copy of OTPTimerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OTPTimerStateCopyWith<OTPTimerState> get copyWith => _$OTPTimerStateCopyWithImpl<OTPTimerState>(this as OTPTimerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OTPTimerState&&(identical(other.timeLeft, timeLeft) || other.timeLeft == timeLeft)&&(identical(other.isExpired, isExpired) || other.isExpired == isExpired)&&(identical(other.canResend, canResend) || other.canResend == canResend));
}


@override
int get hashCode => Object.hash(runtimeType,timeLeft,isExpired,canResend);

@override
String toString() {
  return 'OTPTimerState(timeLeft: $timeLeft, isExpired: $isExpired, canResend: $canResend)';
}


}

/// @nodoc
abstract mixin class $OTPTimerStateCopyWith<$Res>  {
  factory $OTPTimerStateCopyWith(OTPTimerState value, $Res Function(OTPTimerState) _then) = _$OTPTimerStateCopyWithImpl;
@useResult
$Res call({
 int timeLeft, bool isExpired, bool canResend
});




}
/// @nodoc
class _$OTPTimerStateCopyWithImpl<$Res>
    implements $OTPTimerStateCopyWith<$Res> {
  _$OTPTimerStateCopyWithImpl(this._self, this._then);

  final OTPTimerState _self;
  final $Res Function(OTPTimerState) _then;

/// Create a copy of OTPTimerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timeLeft = null,Object? isExpired = null,Object? canResend = null,}) {
  return _then(_self.copyWith(
timeLeft: null == timeLeft ? _self.timeLeft : timeLeft // ignore: cast_nullable_to_non_nullable
as int,isExpired: null == isExpired ? _self.isExpired : isExpired // ignore: cast_nullable_to_non_nullable
as bool,canResend: null == canResend ? _self.canResend : canResend // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OTPTimerState].
extension OTPTimerStatePatterns on OTPTimerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OTPTimerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OTPTimerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OTPTimerState value)  $default,){
final _that = this;
switch (_that) {
case _OTPTimerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OTPTimerState value)?  $default,){
final _that = this;
switch (_that) {
case _OTPTimerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int timeLeft,  bool isExpired,  bool canResend)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OTPTimerState() when $default != null:
return $default(_that.timeLeft,_that.isExpired,_that.canResend);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int timeLeft,  bool isExpired,  bool canResend)  $default,) {final _that = this;
switch (_that) {
case _OTPTimerState():
return $default(_that.timeLeft,_that.isExpired,_that.canResend);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int timeLeft,  bool isExpired,  bool canResend)?  $default,) {final _that = this;
switch (_that) {
case _OTPTimerState() when $default != null:
return $default(_that.timeLeft,_that.isExpired,_that.canResend);case _:
  return null;

}
}

}

/// @nodoc


class _OTPTimerState extends OTPTimerState {
  const _OTPTimerState({required this.timeLeft, required this.isExpired, required this.canResend}): super._();
  

@override final  int timeLeft;
@override final  bool isExpired;
@override final  bool canResend;

/// Create a copy of OTPTimerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OTPTimerStateCopyWith<_OTPTimerState> get copyWith => __$OTPTimerStateCopyWithImpl<_OTPTimerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OTPTimerState&&(identical(other.timeLeft, timeLeft) || other.timeLeft == timeLeft)&&(identical(other.isExpired, isExpired) || other.isExpired == isExpired)&&(identical(other.canResend, canResend) || other.canResend == canResend));
}


@override
int get hashCode => Object.hash(runtimeType,timeLeft,isExpired,canResend);

@override
String toString() {
  return 'OTPTimerState(timeLeft: $timeLeft, isExpired: $isExpired, canResend: $canResend)';
}


}

/// @nodoc
abstract mixin class _$OTPTimerStateCopyWith<$Res> implements $OTPTimerStateCopyWith<$Res> {
  factory _$OTPTimerStateCopyWith(_OTPTimerState value, $Res Function(_OTPTimerState) _then) = __$OTPTimerStateCopyWithImpl;
@override @useResult
$Res call({
 int timeLeft, bool isExpired, bool canResend
});




}
/// @nodoc
class __$OTPTimerStateCopyWithImpl<$Res>
    implements _$OTPTimerStateCopyWith<$Res> {
  __$OTPTimerStateCopyWithImpl(this._self, this._then);

  final _OTPTimerState _self;
  final $Res Function(_OTPTimerState) _then;

/// Create a copy of OTPTimerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timeLeft = null,Object? isExpired = null,Object? canResend = null,}) {
  return _then(_OTPTimerState(
timeLeft: null == timeLeft ? _self.timeLeft : timeLeft // ignore: cast_nullable_to_non_nullable
as int,isExpired: null == isExpired ? _self.isExpired : isExpired // ignore: cast_nullable_to_non_nullable
as bool,canResend: null == canResend ? _self.canResend : canResend // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
