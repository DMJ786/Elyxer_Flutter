// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingData {

 DateTime? get birthdate; Gender? get gender; String? get customGenderIdentity; List<String> get genderIdentityOptionIds; List<String> get pronouns; String? get customPronoun; bool get showGenderOnProfile; bool get showPronounsOnProfile; SexualOrientation? get sexualOrientation; bool get showSexualOrientationOnProfile; List<DatingPreference> get datingPreferences; List<String> get datingGoalIds;// Module 4 fields
 String? get industry; String? get role; EducationLevel? get educationLevel; String? get locationQuery; double? get latitude; double? get longitude;
/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingDataCopyWith<OnboardingData> get copyWith => _$OnboardingDataCopyWithImpl<OnboardingData>(this as OnboardingData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingData&&(identical(other.birthdate, birthdate) || other.birthdate == birthdate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.customGenderIdentity, customGenderIdentity) || other.customGenderIdentity == customGenderIdentity)&&const DeepCollectionEquality().equals(other.genderIdentityOptionIds, genderIdentityOptionIds)&&const DeepCollectionEquality().equals(other.pronouns, pronouns)&&(identical(other.customPronoun, customPronoun) || other.customPronoun == customPronoun)&&(identical(other.showGenderOnProfile, showGenderOnProfile) || other.showGenderOnProfile == showGenderOnProfile)&&(identical(other.showPronounsOnProfile, showPronounsOnProfile) || other.showPronounsOnProfile == showPronounsOnProfile)&&(identical(other.sexualOrientation, sexualOrientation) || other.sexualOrientation == sexualOrientation)&&(identical(other.showSexualOrientationOnProfile, showSexualOrientationOnProfile) || other.showSexualOrientationOnProfile == showSexualOrientationOnProfile)&&const DeepCollectionEquality().equals(other.datingPreferences, datingPreferences)&&const DeepCollectionEquality().equals(other.datingGoalIds, datingGoalIds)&&(identical(other.industry, industry) || other.industry == industry)&&(identical(other.role, role) || other.role == role)&&(identical(other.educationLevel, educationLevel) || other.educationLevel == educationLevel)&&(identical(other.locationQuery, locationQuery) || other.locationQuery == locationQuery)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode => Object.hash(runtimeType,birthdate,gender,customGenderIdentity,const DeepCollectionEquality().hash(genderIdentityOptionIds),const DeepCollectionEquality().hash(pronouns),customPronoun,showGenderOnProfile,showPronounsOnProfile,sexualOrientation,showSexualOrientationOnProfile,const DeepCollectionEquality().hash(datingPreferences),const DeepCollectionEquality().hash(datingGoalIds),industry,role,educationLevel,locationQuery,latitude,longitude);

@override
String toString() {
  return 'OnboardingData(birthdate: $birthdate, gender: $gender, customGenderIdentity: $customGenderIdentity, genderIdentityOptionIds: $genderIdentityOptionIds, pronouns: $pronouns, customPronoun: $customPronoun, showGenderOnProfile: $showGenderOnProfile, showPronounsOnProfile: $showPronounsOnProfile, sexualOrientation: $sexualOrientation, showSexualOrientationOnProfile: $showSexualOrientationOnProfile, datingPreferences: $datingPreferences, datingGoalIds: $datingGoalIds, industry: $industry, role: $role, educationLevel: $educationLevel, locationQuery: $locationQuery, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $OnboardingDataCopyWith<$Res>  {
  factory $OnboardingDataCopyWith(OnboardingData value, $Res Function(OnboardingData) _then) = _$OnboardingDataCopyWithImpl;
@useResult
$Res call({
 DateTime? birthdate, Gender? gender, String? customGenderIdentity, List<String> genderIdentityOptionIds, List<String> pronouns, String? customPronoun, bool showGenderOnProfile, bool showPronounsOnProfile, SexualOrientation? sexualOrientation, bool showSexualOrientationOnProfile, List<DatingPreference> datingPreferences, List<String> datingGoalIds, String? industry, String? role, EducationLevel? educationLevel, String? locationQuery, double? latitude, double? longitude
});




}
/// @nodoc
class _$OnboardingDataCopyWithImpl<$Res>
    implements $OnboardingDataCopyWith<$Res> {
  _$OnboardingDataCopyWithImpl(this._self, this._then);

  final OnboardingData _self;
  final $Res Function(OnboardingData) _then;

/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? birthdate = freezed,Object? gender = freezed,Object? customGenderIdentity = freezed,Object? genderIdentityOptionIds = null,Object? pronouns = null,Object? customPronoun = freezed,Object? showGenderOnProfile = null,Object? showPronounsOnProfile = null,Object? sexualOrientation = freezed,Object? showSexualOrientationOnProfile = null,Object? datingPreferences = null,Object? datingGoalIds = null,Object? industry = freezed,Object? role = freezed,Object? educationLevel = freezed,Object? locationQuery = freezed,Object? latitude = freezed,Object? longitude = freezed,}) {
  return _then(_self.copyWith(
birthdate: freezed == birthdate ? _self.birthdate : birthdate // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,customGenderIdentity: freezed == customGenderIdentity ? _self.customGenderIdentity : customGenderIdentity // ignore: cast_nullable_to_non_nullable
as String?,genderIdentityOptionIds: null == genderIdentityOptionIds ? _self.genderIdentityOptionIds : genderIdentityOptionIds // ignore: cast_nullable_to_non_nullable
as List<String>,pronouns: null == pronouns ? _self.pronouns : pronouns // ignore: cast_nullable_to_non_nullable
as List<String>,customPronoun: freezed == customPronoun ? _self.customPronoun : customPronoun // ignore: cast_nullable_to_non_nullable
as String?,showGenderOnProfile: null == showGenderOnProfile ? _self.showGenderOnProfile : showGenderOnProfile // ignore: cast_nullable_to_non_nullable
as bool,showPronounsOnProfile: null == showPronounsOnProfile ? _self.showPronounsOnProfile : showPronounsOnProfile // ignore: cast_nullable_to_non_nullable
as bool,sexualOrientation: freezed == sexualOrientation ? _self.sexualOrientation : sexualOrientation // ignore: cast_nullable_to_non_nullable
as SexualOrientation?,showSexualOrientationOnProfile: null == showSexualOrientationOnProfile ? _self.showSexualOrientationOnProfile : showSexualOrientationOnProfile // ignore: cast_nullable_to_non_nullable
as bool,datingPreferences: null == datingPreferences ? _self.datingPreferences : datingPreferences // ignore: cast_nullable_to_non_nullable
as List<DatingPreference>,datingGoalIds: null == datingGoalIds ? _self.datingGoalIds : datingGoalIds // ignore: cast_nullable_to_non_nullable
as List<String>,industry: freezed == industry ? _self.industry : industry // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,educationLevel: freezed == educationLevel ? _self.educationLevel : educationLevel // ignore: cast_nullable_to_non_nullable
as EducationLevel?,locationQuery: freezed == locationQuery ? _self.locationQuery : locationQuery // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingData].
extension OnboardingDataPatterns on OnboardingData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingData value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingData value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? birthdate,  Gender? gender,  String? customGenderIdentity,  List<String> genderIdentityOptionIds,  List<String> pronouns,  String? customPronoun,  bool showGenderOnProfile,  bool showPronounsOnProfile,  SexualOrientation? sexualOrientation,  bool showSexualOrientationOnProfile,  List<DatingPreference> datingPreferences,  List<String> datingGoalIds,  String? industry,  String? role,  EducationLevel? educationLevel,  String? locationQuery,  double? latitude,  double? longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
return $default(_that.birthdate,_that.gender,_that.customGenderIdentity,_that.genderIdentityOptionIds,_that.pronouns,_that.customPronoun,_that.showGenderOnProfile,_that.showPronounsOnProfile,_that.sexualOrientation,_that.showSexualOrientationOnProfile,_that.datingPreferences,_that.datingGoalIds,_that.industry,_that.role,_that.educationLevel,_that.locationQuery,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? birthdate,  Gender? gender,  String? customGenderIdentity,  List<String> genderIdentityOptionIds,  List<String> pronouns,  String? customPronoun,  bool showGenderOnProfile,  bool showPronounsOnProfile,  SexualOrientation? sexualOrientation,  bool showSexualOrientationOnProfile,  List<DatingPreference> datingPreferences,  List<String> datingGoalIds,  String? industry,  String? role,  EducationLevel? educationLevel,  String? locationQuery,  double? latitude,  double? longitude)  $default,) {final _that = this;
switch (_that) {
case _OnboardingData():
return $default(_that.birthdate,_that.gender,_that.customGenderIdentity,_that.genderIdentityOptionIds,_that.pronouns,_that.customPronoun,_that.showGenderOnProfile,_that.showPronounsOnProfile,_that.sexualOrientation,_that.showSexualOrientationOnProfile,_that.datingPreferences,_that.datingGoalIds,_that.industry,_that.role,_that.educationLevel,_that.locationQuery,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? birthdate,  Gender? gender,  String? customGenderIdentity,  List<String> genderIdentityOptionIds,  List<String> pronouns,  String? customPronoun,  bool showGenderOnProfile,  bool showPronounsOnProfile,  SexualOrientation? sexualOrientation,  bool showSexualOrientationOnProfile,  List<DatingPreference> datingPreferences,  List<String> datingGoalIds,  String? industry,  String? role,  EducationLevel? educationLevel,  String? locationQuery,  double? latitude,  double? longitude)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
return $default(_that.birthdate,_that.gender,_that.customGenderIdentity,_that.genderIdentityOptionIds,_that.pronouns,_that.customPronoun,_that.showGenderOnProfile,_that.showPronounsOnProfile,_that.sexualOrientation,_that.showSexualOrientationOnProfile,_that.datingPreferences,_that.datingGoalIds,_that.industry,_that.role,_that.educationLevel,_that.locationQuery,_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingData implements OnboardingData {
  const _OnboardingData({this.birthdate, this.gender, this.customGenderIdentity, final  List<String> genderIdentityOptionIds = const [], final  List<String> pronouns = const [], this.customPronoun, this.showGenderOnProfile = false, this.showPronounsOnProfile = false, this.sexualOrientation, this.showSexualOrientationOnProfile = false, final  List<DatingPreference> datingPreferences = const [], final  List<String> datingGoalIds = const [], this.industry, this.role, this.educationLevel, this.locationQuery, this.latitude, this.longitude}): _genderIdentityOptionIds = genderIdentityOptionIds,_pronouns = pronouns,_datingPreferences = datingPreferences,_datingGoalIds = datingGoalIds;
  

@override final  DateTime? birthdate;
@override final  Gender? gender;
@override final  String? customGenderIdentity;
 final  List<String> _genderIdentityOptionIds;
@override@JsonKey() List<String> get genderIdentityOptionIds {
  if (_genderIdentityOptionIds is EqualUnmodifiableListView) return _genderIdentityOptionIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genderIdentityOptionIds);
}

 final  List<String> _pronouns;
@override@JsonKey() List<String> get pronouns {
  if (_pronouns is EqualUnmodifiableListView) return _pronouns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pronouns);
}

@override final  String? customPronoun;
@override@JsonKey() final  bool showGenderOnProfile;
@override@JsonKey() final  bool showPronounsOnProfile;
@override final  SexualOrientation? sexualOrientation;
@override@JsonKey() final  bool showSexualOrientationOnProfile;
 final  List<DatingPreference> _datingPreferences;
@override@JsonKey() List<DatingPreference> get datingPreferences {
  if (_datingPreferences is EqualUnmodifiableListView) return _datingPreferences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_datingPreferences);
}

 final  List<String> _datingGoalIds;
@override@JsonKey() List<String> get datingGoalIds {
  if (_datingGoalIds is EqualUnmodifiableListView) return _datingGoalIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_datingGoalIds);
}

// Module 4 fields
@override final  String? industry;
@override final  String? role;
@override final  EducationLevel? educationLevel;
@override final  String? locationQuery;
@override final  double? latitude;
@override final  double? longitude;

/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingDataCopyWith<_OnboardingData> get copyWith => __$OnboardingDataCopyWithImpl<_OnboardingData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingData&&(identical(other.birthdate, birthdate) || other.birthdate == birthdate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.customGenderIdentity, customGenderIdentity) || other.customGenderIdentity == customGenderIdentity)&&const DeepCollectionEquality().equals(other._genderIdentityOptionIds, _genderIdentityOptionIds)&&const DeepCollectionEquality().equals(other._pronouns, _pronouns)&&(identical(other.customPronoun, customPronoun) || other.customPronoun == customPronoun)&&(identical(other.showGenderOnProfile, showGenderOnProfile) || other.showGenderOnProfile == showGenderOnProfile)&&(identical(other.showPronounsOnProfile, showPronounsOnProfile) || other.showPronounsOnProfile == showPronounsOnProfile)&&(identical(other.sexualOrientation, sexualOrientation) || other.sexualOrientation == sexualOrientation)&&(identical(other.showSexualOrientationOnProfile, showSexualOrientationOnProfile) || other.showSexualOrientationOnProfile == showSexualOrientationOnProfile)&&const DeepCollectionEquality().equals(other._datingPreferences, _datingPreferences)&&const DeepCollectionEquality().equals(other._datingGoalIds, _datingGoalIds)&&(identical(other.industry, industry) || other.industry == industry)&&(identical(other.role, role) || other.role == role)&&(identical(other.educationLevel, educationLevel) || other.educationLevel == educationLevel)&&(identical(other.locationQuery, locationQuery) || other.locationQuery == locationQuery)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode => Object.hash(runtimeType,birthdate,gender,customGenderIdentity,const DeepCollectionEquality().hash(_genderIdentityOptionIds),const DeepCollectionEquality().hash(_pronouns),customPronoun,showGenderOnProfile,showPronounsOnProfile,sexualOrientation,showSexualOrientationOnProfile,const DeepCollectionEquality().hash(_datingPreferences),const DeepCollectionEquality().hash(_datingGoalIds),industry,role,educationLevel,locationQuery,latitude,longitude);

@override
String toString() {
  return 'OnboardingData(birthdate: $birthdate, gender: $gender, customGenderIdentity: $customGenderIdentity, genderIdentityOptionIds: $genderIdentityOptionIds, pronouns: $pronouns, customPronoun: $customPronoun, showGenderOnProfile: $showGenderOnProfile, showPronounsOnProfile: $showPronounsOnProfile, sexualOrientation: $sexualOrientation, showSexualOrientationOnProfile: $showSexualOrientationOnProfile, datingPreferences: $datingPreferences, datingGoalIds: $datingGoalIds, industry: $industry, role: $role, educationLevel: $educationLevel, locationQuery: $locationQuery, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$OnboardingDataCopyWith<$Res> implements $OnboardingDataCopyWith<$Res> {
  factory _$OnboardingDataCopyWith(_OnboardingData value, $Res Function(_OnboardingData) _then) = __$OnboardingDataCopyWithImpl;
@override @useResult
$Res call({
 DateTime? birthdate, Gender? gender, String? customGenderIdentity, List<String> genderIdentityOptionIds, List<String> pronouns, String? customPronoun, bool showGenderOnProfile, bool showPronounsOnProfile, SexualOrientation? sexualOrientation, bool showSexualOrientationOnProfile, List<DatingPreference> datingPreferences, List<String> datingGoalIds, String? industry, String? role, EducationLevel? educationLevel, String? locationQuery, double? latitude, double? longitude
});




}
/// @nodoc
class __$OnboardingDataCopyWithImpl<$Res>
    implements _$OnboardingDataCopyWith<$Res> {
  __$OnboardingDataCopyWithImpl(this._self, this._then);

  final _OnboardingData _self;
  final $Res Function(_OnboardingData) _then;

/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? birthdate = freezed,Object? gender = freezed,Object? customGenderIdentity = freezed,Object? genderIdentityOptionIds = null,Object? pronouns = null,Object? customPronoun = freezed,Object? showGenderOnProfile = null,Object? showPronounsOnProfile = null,Object? sexualOrientation = freezed,Object? showSexualOrientationOnProfile = null,Object? datingPreferences = null,Object? datingGoalIds = null,Object? industry = freezed,Object? role = freezed,Object? educationLevel = freezed,Object? locationQuery = freezed,Object? latitude = freezed,Object? longitude = freezed,}) {
  return _then(_OnboardingData(
birthdate: freezed == birthdate ? _self.birthdate : birthdate // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,customGenderIdentity: freezed == customGenderIdentity ? _self.customGenderIdentity : customGenderIdentity // ignore: cast_nullable_to_non_nullable
as String?,genderIdentityOptionIds: null == genderIdentityOptionIds ? _self._genderIdentityOptionIds : genderIdentityOptionIds // ignore: cast_nullable_to_non_nullable
as List<String>,pronouns: null == pronouns ? _self._pronouns : pronouns // ignore: cast_nullable_to_non_nullable
as List<String>,customPronoun: freezed == customPronoun ? _self.customPronoun : customPronoun // ignore: cast_nullable_to_non_nullable
as String?,showGenderOnProfile: null == showGenderOnProfile ? _self.showGenderOnProfile : showGenderOnProfile // ignore: cast_nullable_to_non_nullable
as bool,showPronounsOnProfile: null == showPronounsOnProfile ? _self.showPronounsOnProfile : showPronounsOnProfile // ignore: cast_nullable_to_non_nullable
as bool,sexualOrientation: freezed == sexualOrientation ? _self.sexualOrientation : sexualOrientation // ignore: cast_nullable_to_non_nullable
as SexualOrientation?,showSexualOrientationOnProfile: null == showSexualOrientationOnProfile ? _self.showSexualOrientationOnProfile : showSexualOrientationOnProfile // ignore: cast_nullable_to_non_nullable
as bool,datingPreferences: null == datingPreferences ? _self._datingPreferences : datingPreferences // ignore: cast_nullable_to_non_nullable
as List<DatingPreference>,datingGoalIds: null == datingGoalIds ? _self._datingGoalIds : datingGoalIds // ignore: cast_nullable_to_non_nullable
as List<String>,industry: freezed == industry ? _self.industry : industry // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,educationLevel: freezed == educationLevel ? _self.educationLevel : educationLevel // ignore: cast_nullable_to_non_nullable
as EducationLevel?,locationQuery: freezed == locationQuery ? _self.locationQuery : locationQuery // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc
mixin _$DatingGoal {

 String get id; String get title; String get subtitle;
/// Create a copy of DatingGoal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DatingGoalCopyWith<DatingGoal> get copyWith => _$DatingGoalCopyWithImpl<DatingGoal>(this as DatingGoal, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DatingGoal&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle);

@override
String toString() {
  return 'DatingGoal(id: $id, title: $title, subtitle: $subtitle)';
}


}

/// @nodoc
abstract mixin class $DatingGoalCopyWith<$Res>  {
  factory $DatingGoalCopyWith(DatingGoal value, $Res Function(DatingGoal) _then) = _$DatingGoalCopyWithImpl;
@useResult
$Res call({
 String id, String title, String subtitle
});




}
/// @nodoc
class _$DatingGoalCopyWithImpl<$Res>
    implements $DatingGoalCopyWith<$Res> {
  _$DatingGoalCopyWithImpl(this._self, this._then);

  final DatingGoal _self;
  final $Res Function(DatingGoal) _then;

/// Create a copy of DatingGoal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? subtitle = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DatingGoal].
extension DatingGoalPatterns on DatingGoal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DatingGoal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DatingGoal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DatingGoal value)  $default,){
final _that = this;
switch (_that) {
case _DatingGoal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DatingGoal value)?  $default,){
final _that = this;
switch (_that) {
case _DatingGoal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String subtitle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DatingGoal() when $default != null:
return $default(_that.id,_that.title,_that.subtitle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String subtitle)  $default,) {final _that = this;
switch (_that) {
case _DatingGoal():
return $default(_that.id,_that.title,_that.subtitle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String subtitle)?  $default,) {final _that = this;
switch (_that) {
case _DatingGoal() when $default != null:
return $default(_that.id,_that.title,_that.subtitle);case _:
  return null;

}
}

}

/// @nodoc


class _DatingGoal extends DatingGoal {
  const _DatingGoal({required this.id, required this.title, required this.subtitle}): super._();
  

@override final  String id;
@override final  String title;
@override final  String subtitle;

/// Create a copy of DatingGoal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DatingGoalCopyWith<_DatingGoal> get copyWith => __$DatingGoalCopyWithImpl<_DatingGoal>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DatingGoal&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle);

@override
String toString() {
  return 'DatingGoal(id: $id, title: $title, subtitle: $subtitle)';
}


}

/// @nodoc
abstract mixin class _$DatingGoalCopyWith<$Res> implements $DatingGoalCopyWith<$Res> {
  factory _$DatingGoalCopyWith(_DatingGoal value, $Res Function(_DatingGoal) _then) = __$DatingGoalCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String subtitle
});




}
/// @nodoc
class __$DatingGoalCopyWithImpl<$Res>
    implements _$DatingGoalCopyWith<$Res> {
  __$DatingGoalCopyWithImpl(this._self, this._then);

  final _DatingGoal _self;
  final $Res Function(_DatingGoal) _then;

/// Create a copy of DatingGoal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? subtitle = null,}) {
  return _then(_DatingGoal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
