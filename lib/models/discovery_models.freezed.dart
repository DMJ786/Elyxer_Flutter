// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discovery_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileAbout {

 String get gender; String get pronouns; String get orientation; String get education; String get height;
/// Create a copy of ProfileAbout
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileAboutCopyWith<ProfileAbout> get copyWith => _$ProfileAboutCopyWithImpl<ProfileAbout>(this as ProfileAbout, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileAbout&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.pronouns, pronouns) || other.pronouns == pronouns)&&(identical(other.orientation, orientation) || other.orientation == orientation)&&(identical(other.education, education) || other.education == education)&&(identical(other.height, height) || other.height == height));
}


@override
int get hashCode => Object.hash(runtimeType,gender,pronouns,orientation,education,height);

@override
String toString() {
  return 'ProfileAbout(gender: $gender, pronouns: $pronouns, orientation: $orientation, education: $education, height: $height)';
}


}

/// @nodoc
abstract mixin class $ProfileAboutCopyWith<$Res>  {
  factory $ProfileAboutCopyWith(ProfileAbout value, $Res Function(ProfileAbout) _then) = _$ProfileAboutCopyWithImpl;
@useResult
$Res call({
 String gender, String pronouns, String orientation, String education, String height
});




}
/// @nodoc
class _$ProfileAboutCopyWithImpl<$Res>
    implements $ProfileAboutCopyWith<$Res> {
  _$ProfileAboutCopyWithImpl(this._self, this._then);

  final ProfileAbout _self;
  final $Res Function(ProfileAbout) _then;

/// Create a copy of ProfileAbout
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gender = null,Object? pronouns = null,Object? orientation = null,Object? education = null,Object? height = null,}) {
  return _then(_self.copyWith(
gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,pronouns: null == pronouns ? _self.pronouns : pronouns // ignore: cast_nullable_to_non_nullable
as String,orientation: null == orientation ? _self.orientation : orientation // ignore: cast_nullable_to_non_nullable
as String,education: null == education ? _self.education : education // ignore: cast_nullable_to_non_nullable
as String,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileAbout].
extension ProfileAboutPatterns on ProfileAbout {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileAbout value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileAbout() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileAbout value)  $default,){
final _that = this;
switch (_that) {
case _ProfileAbout():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileAbout value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileAbout() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String gender,  String pronouns,  String orientation,  String education,  String height)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileAbout() when $default != null:
return $default(_that.gender,_that.pronouns,_that.orientation,_that.education,_that.height);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String gender,  String pronouns,  String orientation,  String education,  String height)  $default,) {final _that = this;
switch (_that) {
case _ProfileAbout():
return $default(_that.gender,_that.pronouns,_that.orientation,_that.education,_that.height);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String gender,  String pronouns,  String orientation,  String education,  String height)?  $default,) {final _that = this;
switch (_that) {
case _ProfileAbout() when $default != null:
return $default(_that.gender,_that.pronouns,_that.orientation,_that.education,_that.height);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileAbout implements ProfileAbout {
  const _ProfileAbout({required this.gender, required this.pronouns, required this.orientation, required this.education, required this.height});
  

@override final  String gender;
@override final  String pronouns;
@override final  String orientation;
@override final  String education;
@override final  String height;

/// Create a copy of ProfileAbout
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileAboutCopyWith<_ProfileAbout> get copyWith => __$ProfileAboutCopyWithImpl<_ProfileAbout>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileAbout&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.pronouns, pronouns) || other.pronouns == pronouns)&&(identical(other.orientation, orientation) || other.orientation == orientation)&&(identical(other.education, education) || other.education == education)&&(identical(other.height, height) || other.height == height));
}


@override
int get hashCode => Object.hash(runtimeType,gender,pronouns,orientation,education,height);

@override
String toString() {
  return 'ProfileAbout(gender: $gender, pronouns: $pronouns, orientation: $orientation, education: $education, height: $height)';
}


}

/// @nodoc
abstract mixin class _$ProfileAboutCopyWith<$Res> implements $ProfileAboutCopyWith<$Res> {
  factory _$ProfileAboutCopyWith(_ProfileAbout value, $Res Function(_ProfileAbout) _then) = __$ProfileAboutCopyWithImpl;
@override @useResult
$Res call({
 String gender, String pronouns, String orientation, String education, String height
});




}
/// @nodoc
class __$ProfileAboutCopyWithImpl<$Res>
    implements _$ProfileAboutCopyWith<$Res> {
  __$ProfileAboutCopyWithImpl(this._self, this._then);

  final _ProfileAbout _self;
  final $Res Function(_ProfileAbout) _then;

/// Create a copy of ProfileAbout
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gender = null,Object? pronouns = null,Object? orientation = null,Object? education = null,Object? height = null,}) {
  return _then(_ProfileAbout(
gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,pronouns: null == pronouns ? _self.pronouns : pronouns // ignore: cast_nullable_to_non_nullable
as String,orientation: null == orientation ? _self.orientation : orientation // ignore: cast_nullable_to_non_nullable
as String,education: null == education ? _self.education : education // ignore: cast_nullable_to_non_nullable
as String,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ProfileNarrative {

 String get title; String get content;
/// Create a copy of ProfileNarrative
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileNarrativeCopyWith<ProfileNarrative> get copyWith => _$ProfileNarrativeCopyWithImpl<ProfileNarrative>(this as ProfileNarrative, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileNarrative&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,title,content);

@override
String toString() {
  return 'ProfileNarrative(title: $title, content: $content)';
}


}

/// @nodoc
abstract mixin class $ProfileNarrativeCopyWith<$Res>  {
  factory $ProfileNarrativeCopyWith(ProfileNarrative value, $Res Function(ProfileNarrative) _then) = _$ProfileNarrativeCopyWithImpl;
@useResult
$Res call({
 String title, String content
});




}
/// @nodoc
class _$ProfileNarrativeCopyWithImpl<$Res>
    implements $ProfileNarrativeCopyWith<$Res> {
  _$ProfileNarrativeCopyWithImpl(this._self, this._then);

  final ProfileNarrative _self;
  final $Res Function(ProfileNarrative) _then;

/// Create a copy of ProfileNarrative
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? content = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileNarrative].
extension ProfileNarrativePatterns on ProfileNarrative {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileNarrative value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileNarrative() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileNarrative value)  $default,){
final _that = this;
switch (_that) {
case _ProfileNarrative():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileNarrative value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileNarrative() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileNarrative() when $default != null:
return $default(_that.title,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String content)  $default,) {final _that = this;
switch (_that) {
case _ProfileNarrative():
return $default(_that.title,_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String content)?  $default,) {final _that = this;
switch (_that) {
case _ProfileNarrative() when $default != null:
return $default(_that.title,_that.content);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileNarrative implements ProfileNarrative {
  const _ProfileNarrative({required this.title, required this.content});
  

@override final  String title;
@override final  String content;

/// Create a copy of ProfileNarrative
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileNarrativeCopyWith<_ProfileNarrative> get copyWith => __$ProfileNarrativeCopyWithImpl<_ProfileNarrative>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileNarrative&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,title,content);

@override
String toString() {
  return 'ProfileNarrative(title: $title, content: $content)';
}


}

/// @nodoc
abstract mixin class _$ProfileNarrativeCopyWith<$Res> implements $ProfileNarrativeCopyWith<$Res> {
  factory _$ProfileNarrativeCopyWith(_ProfileNarrative value, $Res Function(_ProfileNarrative) _then) = __$ProfileNarrativeCopyWithImpl;
@override @useResult
$Res call({
 String title, String content
});




}
/// @nodoc
class __$ProfileNarrativeCopyWithImpl<$Res>
    implements _$ProfileNarrativeCopyWith<$Res> {
  __$ProfileNarrativeCopyWithImpl(this._self, this._then);

  final _ProfileNarrative _self;
  final $Res Function(_ProfileNarrative) _then;

/// Create a copy of ProfileNarrative
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? content = null,}) {
  return _then(_ProfileNarrative(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$DiscoveryProfile {

 String get id; String get name; int get age; String get occupation; String get location;/// Portrait photo urls, interleaved between the info sections.
 List<String> get photos; String get myStory; ProfileAbout get about; List<String> get languages; List<String> get intents; List<String> get interests; List<ProfileNarrative> get narratives; List<String> get joinMeFor;/// Verified badge next to the name.
 bool get verified;
/// Create a copy of DiscoveryProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoveryProfileCopyWith<DiscoveryProfile> get copyWith => _$DiscoveryProfileCopyWithImpl<DiscoveryProfile>(this as DiscoveryProfile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoveryProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.age, age) || other.age == age)&&(identical(other.occupation, occupation) || other.occupation == occupation)&&(identical(other.location, location) || other.location == location)&&const DeepCollectionEquality().equals(other.photos, photos)&&(identical(other.myStory, myStory) || other.myStory == myStory)&&(identical(other.about, about) || other.about == about)&&const DeepCollectionEquality().equals(other.languages, languages)&&const DeepCollectionEquality().equals(other.intents, intents)&&const DeepCollectionEquality().equals(other.interests, interests)&&const DeepCollectionEquality().equals(other.narratives, narratives)&&const DeepCollectionEquality().equals(other.joinMeFor, joinMeFor)&&(identical(other.verified, verified) || other.verified == verified));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,age,occupation,location,const DeepCollectionEquality().hash(photos),myStory,about,const DeepCollectionEquality().hash(languages),const DeepCollectionEquality().hash(intents),const DeepCollectionEquality().hash(interests),const DeepCollectionEquality().hash(narratives),const DeepCollectionEquality().hash(joinMeFor),verified);

@override
String toString() {
  return 'DiscoveryProfile(id: $id, name: $name, age: $age, occupation: $occupation, location: $location, photos: $photos, myStory: $myStory, about: $about, languages: $languages, intents: $intents, interests: $interests, narratives: $narratives, joinMeFor: $joinMeFor, verified: $verified)';
}


}

/// @nodoc
abstract mixin class $DiscoveryProfileCopyWith<$Res>  {
  factory $DiscoveryProfileCopyWith(DiscoveryProfile value, $Res Function(DiscoveryProfile) _then) = _$DiscoveryProfileCopyWithImpl;
@useResult
$Res call({
 String id, String name, int age, String occupation, String location, List<String> photos, String myStory, ProfileAbout about, List<String> languages, List<String> intents, List<String> interests, List<ProfileNarrative> narratives, List<String> joinMeFor, bool verified
});


$ProfileAboutCopyWith<$Res> get about;

}
/// @nodoc
class _$DiscoveryProfileCopyWithImpl<$Res>
    implements $DiscoveryProfileCopyWith<$Res> {
  _$DiscoveryProfileCopyWithImpl(this._self, this._then);

  final DiscoveryProfile _self;
  final $Res Function(DiscoveryProfile) _then;

/// Create a copy of DiscoveryProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? age = null,Object? occupation = null,Object? location = null,Object? photos = null,Object? myStory = null,Object? about = null,Object? languages = null,Object? intents = null,Object? interests = null,Object? narratives = null,Object? joinMeFor = null,Object? verified = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,occupation: null == occupation ? _self.occupation : occupation // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<String>,myStory: null == myStory ? _self.myStory : myStory // ignore: cast_nullable_to_non_nullable
as String,about: null == about ? _self.about : about // ignore: cast_nullable_to_non_nullable
as ProfileAbout,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,intents: null == intents ? _self.intents : intents // ignore: cast_nullable_to_non_nullable
as List<String>,interests: null == interests ? _self.interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,narratives: null == narratives ? _self.narratives : narratives // ignore: cast_nullable_to_non_nullable
as List<ProfileNarrative>,joinMeFor: null == joinMeFor ? _self.joinMeFor : joinMeFor // ignore: cast_nullable_to_non_nullable
as List<String>,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of DiscoveryProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileAboutCopyWith<$Res> get about {
  
  return $ProfileAboutCopyWith<$Res>(_self.about, (value) {
    return _then(_self.copyWith(about: value));
  });
}
}


/// Adds pattern-matching-related methods to [DiscoveryProfile].
extension DiscoveryProfilePatterns on DiscoveryProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscoveryProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscoveryProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscoveryProfile value)  $default,){
final _that = this;
switch (_that) {
case _DiscoveryProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscoveryProfile value)?  $default,){
final _that = this;
switch (_that) {
case _DiscoveryProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int age,  String occupation,  String location,  List<String> photos,  String myStory,  ProfileAbout about,  List<String> languages,  List<String> intents,  List<String> interests,  List<ProfileNarrative> narratives,  List<String> joinMeFor,  bool verified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscoveryProfile() when $default != null:
return $default(_that.id,_that.name,_that.age,_that.occupation,_that.location,_that.photos,_that.myStory,_that.about,_that.languages,_that.intents,_that.interests,_that.narratives,_that.joinMeFor,_that.verified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int age,  String occupation,  String location,  List<String> photos,  String myStory,  ProfileAbout about,  List<String> languages,  List<String> intents,  List<String> interests,  List<ProfileNarrative> narratives,  List<String> joinMeFor,  bool verified)  $default,) {final _that = this;
switch (_that) {
case _DiscoveryProfile():
return $default(_that.id,_that.name,_that.age,_that.occupation,_that.location,_that.photos,_that.myStory,_that.about,_that.languages,_that.intents,_that.interests,_that.narratives,_that.joinMeFor,_that.verified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int age,  String occupation,  String location,  List<String> photos,  String myStory,  ProfileAbout about,  List<String> languages,  List<String> intents,  List<String> interests,  List<ProfileNarrative> narratives,  List<String> joinMeFor,  bool verified)?  $default,) {final _that = this;
switch (_that) {
case _DiscoveryProfile() when $default != null:
return $default(_that.id,_that.name,_that.age,_that.occupation,_that.location,_that.photos,_that.myStory,_that.about,_that.languages,_that.intents,_that.interests,_that.narratives,_that.joinMeFor,_that.verified);case _:
  return null;

}
}

}

/// @nodoc


class _DiscoveryProfile implements DiscoveryProfile {
  const _DiscoveryProfile({required this.id, required this.name, required this.age, required this.occupation, required this.location, required final  List<String> photos, required this.myStory, required this.about, final  List<String> languages = const <String>[], final  List<String> intents = const <String>[], final  List<String> interests = const <String>[], final  List<ProfileNarrative> narratives = const <ProfileNarrative>[], final  List<String> joinMeFor = const <String>[], this.verified = true}): _photos = photos,_languages = languages,_intents = intents,_interests = interests,_narratives = narratives,_joinMeFor = joinMeFor;
  

@override final  String id;
@override final  String name;
@override final  int age;
@override final  String occupation;
@override final  String location;
/// Portrait photo urls, interleaved between the info sections.
 final  List<String> _photos;
/// Portrait photo urls, interleaved between the info sections.
@override List<String> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

@override final  String myStory;
@override final  ProfileAbout about;
 final  List<String> _languages;
@override@JsonKey() List<String> get languages {
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_languages);
}

 final  List<String> _intents;
@override@JsonKey() List<String> get intents {
  if (_intents is EqualUnmodifiableListView) return _intents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_intents);
}

 final  List<String> _interests;
@override@JsonKey() List<String> get interests {
  if (_interests is EqualUnmodifiableListView) return _interests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_interests);
}

 final  List<ProfileNarrative> _narratives;
@override@JsonKey() List<ProfileNarrative> get narratives {
  if (_narratives is EqualUnmodifiableListView) return _narratives;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_narratives);
}

 final  List<String> _joinMeFor;
@override@JsonKey() List<String> get joinMeFor {
  if (_joinMeFor is EqualUnmodifiableListView) return _joinMeFor;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_joinMeFor);
}

/// Verified badge next to the name.
@override@JsonKey() final  bool verified;

/// Create a copy of DiscoveryProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscoveryProfileCopyWith<_DiscoveryProfile> get copyWith => __$DiscoveryProfileCopyWithImpl<_DiscoveryProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscoveryProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.age, age) || other.age == age)&&(identical(other.occupation, occupation) || other.occupation == occupation)&&(identical(other.location, location) || other.location == location)&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.myStory, myStory) || other.myStory == myStory)&&(identical(other.about, about) || other.about == about)&&const DeepCollectionEquality().equals(other._languages, _languages)&&const DeepCollectionEquality().equals(other._intents, _intents)&&const DeepCollectionEquality().equals(other._interests, _interests)&&const DeepCollectionEquality().equals(other._narratives, _narratives)&&const DeepCollectionEquality().equals(other._joinMeFor, _joinMeFor)&&(identical(other.verified, verified) || other.verified == verified));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,age,occupation,location,const DeepCollectionEquality().hash(_photos),myStory,about,const DeepCollectionEquality().hash(_languages),const DeepCollectionEquality().hash(_intents),const DeepCollectionEquality().hash(_interests),const DeepCollectionEquality().hash(_narratives),const DeepCollectionEquality().hash(_joinMeFor),verified);

@override
String toString() {
  return 'DiscoveryProfile(id: $id, name: $name, age: $age, occupation: $occupation, location: $location, photos: $photos, myStory: $myStory, about: $about, languages: $languages, intents: $intents, interests: $interests, narratives: $narratives, joinMeFor: $joinMeFor, verified: $verified)';
}


}

/// @nodoc
abstract mixin class _$DiscoveryProfileCopyWith<$Res> implements $DiscoveryProfileCopyWith<$Res> {
  factory _$DiscoveryProfileCopyWith(_DiscoveryProfile value, $Res Function(_DiscoveryProfile) _then) = __$DiscoveryProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int age, String occupation, String location, List<String> photos, String myStory, ProfileAbout about, List<String> languages, List<String> intents, List<String> interests, List<ProfileNarrative> narratives, List<String> joinMeFor, bool verified
});


@override $ProfileAboutCopyWith<$Res> get about;

}
/// @nodoc
class __$DiscoveryProfileCopyWithImpl<$Res>
    implements _$DiscoveryProfileCopyWith<$Res> {
  __$DiscoveryProfileCopyWithImpl(this._self, this._then);

  final _DiscoveryProfile _self;
  final $Res Function(_DiscoveryProfile) _then;

/// Create a copy of DiscoveryProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? age = null,Object? occupation = null,Object? location = null,Object? photos = null,Object? myStory = null,Object? about = null,Object? languages = null,Object? intents = null,Object? interests = null,Object? narratives = null,Object? joinMeFor = null,Object? verified = null,}) {
  return _then(_DiscoveryProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,occupation: null == occupation ? _self.occupation : occupation // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<String>,myStory: null == myStory ? _self.myStory : myStory // ignore: cast_nullable_to_non_nullable
as String,about: null == about ? _self.about : about // ignore: cast_nullable_to_non_nullable
as ProfileAbout,languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,intents: null == intents ? _self._intents : intents // ignore: cast_nullable_to_non_nullable
as List<String>,interests: null == interests ? _self._interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,narratives: null == narratives ? _self._narratives : narratives // ignore: cast_nullable_to_non_nullable
as List<ProfileNarrative>,joinMeFor: null == joinMeFor ? _self._joinMeFor : joinMeFor // ignore: cast_nullable_to_non_nullable
as List<String>,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of DiscoveryProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileAboutCopyWith<$Res> get about {
  
  return $ProfileAboutCopyWith<$Res>(_self.about, (value) {
    return _then(_self.copyWith(about: value));
  });
}
}

// dart format on
