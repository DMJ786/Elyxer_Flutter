// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_studio_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Narrative {

 String get id; String get title; String get content;
/// Create a copy of Narrative
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NarrativeCopyWith<Narrative> get copyWith => _$NarrativeCopyWithImpl<Narrative>(this as Narrative, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Narrative&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,content);

@override
String toString() {
  return 'Narrative(id: $id, title: $title, content: $content)';
}


}

/// @nodoc
abstract mixin class $NarrativeCopyWith<$Res>  {
  factory $NarrativeCopyWith(Narrative value, $Res Function(Narrative) _then) = _$NarrativeCopyWithImpl;
@useResult
$Res call({
 String id, String title, String content
});




}
/// @nodoc
class _$NarrativeCopyWithImpl<$Res>
    implements $NarrativeCopyWith<$Res> {
  _$NarrativeCopyWithImpl(this._self, this._then);

  final Narrative _self;
  final $Res Function(Narrative) _then;

/// Create a copy of Narrative
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? content = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Narrative].
extension NarrativePatterns on Narrative {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Narrative value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Narrative() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Narrative value)  $default,){
final _that = this;
switch (_that) {
case _Narrative():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Narrative value)?  $default,){
final _that = this;
switch (_that) {
case _Narrative() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Narrative() when $default != null:
return $default(_that.id,_that.title,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String content)  $default,) {final _that = this;
switch (_that) {
case _Narrative():
return $default(_that.id,_that.title,_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String content)?  $default,) {final _that = this;
switch (_that) {
case _Narrative() when $default != null:
return $default(_that.id,_that.title,_that.content);case _:
  return null;

}
}

}

/// @nodoc


class _Narrative implements Narrative {
  const _Narrative({required this.id, required this.title, required this.content});
  

@override final  String id;
@override final  String title;
@override final  String content;

/// Create a copy of Narrative
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NarrativeCopyWith<_Narrative> get copyWith => __$NarrativeCopyWithImpl<_Narrative>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Narrative&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,content);

@override
String toString() {
  return 'Narrative(id: $id, title: $title, content: $content)';
}


}

/// @nodoc
abstract mixin class _$NarrativeCopyWith<$Res> implements $NarrativeCopyWith<$Res> {
  factory _$NarrativeCopyWith(_Narrative value, $Res Function(_Narrative) _then) = __$NarrativeCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String content
});




}
/// @nodoc
class __$NarrativeCopyWithImpl<$Res>
    implements _$NarrativeCopyWith<$Res> {
  __$NarrativeCopyWithImpl(this._self, this._then);

  final _Narrative _self;
  final $Res Function(_Narrative) _then;

/// Create a copy of Narrative
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? content = null,}) {
  return _then(_Narrative(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$InspirationSuggestion {

 String get id; String get text; List<String> get tags;
/// Create a copy of InspirationSuggestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InspirationSuggestionCopyWith<InspirationSuggestion> get copyWith => _$InspirationSuggestionCopyWithImpl<InspirationSuggestion>(this as InspirationSuggestion, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InspirationSuggestion&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.tags, tags));
}


@override
int get hashCode => Object.hash(runtimeType,id,text,const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'InspirationSuggestion(id: $id, text: $text, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $InspirationSuggestionCopyWith<$Res>  {
  factory $InspirationSuggestionCopyWith(InspirationSuggestion value, $Res Function(InspirationSuggestion) _then) = _$InspirationSuggestionCopyWithImpl;
@useResult
$Res call({
 String id, String text, List<String> tags
});




}
/// @nodoc
class _$InspirationSuggestionCopyWithImpl<$Res>
    implements $InspirationSuggestionCopyWith<$Res> {
  _$InspirationSuggestionCopyWithImpl(this._self, this._then);

  final InspirationSuggestion _self;
  final $Res Function(InspirationSuggestion) _then;

/// Create a copy of InspirationSuggestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? tags = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [InspirationSuggestion].
extension InspirationSuggestionPatterns on InspirationSuggestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InspirationSuggestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InspirationSuggestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InspirationSuggestion value)  $default,){
final _that = this;
switch (_that) {
case _InspirationSuggestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InspirationSuggestion value)?  $default,){
final _that = this;
switch (_that) {
case _InspirationSuggestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String text,  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InspirationSuggestion() when $default != null:
return $default(_that.id,_that.text,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String text,  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _InspirationSuggestion():
return $default(_that.id,_that.text,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String text,  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _InspirationSuggestion() when $default != null:
return $default(_that.id,_that.text,_that.tags);case _:
  return null;

}
}

}

/// @nodoc


class _InspirationSuggestion implements InspirationSuggestion {
  const _InspirationSuggestion({required this.id, required this.text, final  List<String> tags = const <String>['HOBBIES', 'LIFESTYLE', 'INTENT']}): _tags = tags;
  

@override final  String id;
@override final  String text;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of InspirationSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InspirationSuggestionCopyWith<_InspirationSuggestion> get copyWith => __$InspirationSuggestionCopyWithImpl<_InspirationSuggestion>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InspirationSuggestion&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other._tags, _tags));
}


@override
int get hashCode => Object.hash(runtimeType,id,text,const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'InspirationSuggestion(id: $id, text: $text, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$InspirationSuggestionCopyWith<$Res> implements $InspirationSuggestionCopyWith<$Res> {
  factory _$InspirationSuggestionCopyWith(_InspirationSuggestion value, $Res Function(_InspirationSuggestion) _then) = __$InspirationSuggestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String text, List<String> tags
});




}
/// @nodoc
class __$InspirationSuggestionCopyWithImpl<$Res>
    implements _$InspirationSuggestionCopyWith<$Res> {
  __$InspirationSuggestionCopyWithImpl(this._self, this._then);

  final _InspirationSuggestion _self;
  final $Res Function(_InspirationSuggestion) _then;

/// Create a copy of InspirationSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? tags = null,}) {
  return _then(_InspirationSuggestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$InspirationInputState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InspirationInputState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InspirationInputState()';
}


}

/// @nodoc
class $InspirationInputStateCopyWith<$Res>  {
$InspirationInputStateCopyWith(InspirationInputState _, $Res Function(InspirationInputState) __);
}


/// Adds pattern-matching-related methods to [InspirationInputState].
extension InspirationInputStatePatterns on InspirationInputState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InspirationInputEmpty value)?  empty,TResult Function( InspirationInputTyped value)?  typed,TResult Function( InspirationInputUsed value)?  used,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InspirationInputEmpty() when empty != null:
return empty(_that);case InspirationInputTyped() when typed != null:
return typed(_that);case InspirationInputUsed() when used != null:
return used(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InspirationInputEmpty value)  empty,required TResult Function( InspirationInputTyped value)  typed,required TResult Function( InspirationInputUsed value)  used,}){
final _that = this;
switch (_that) {
case InspirationInputEmpty():
return empty(_that);case InspirationInputTyped():
return typed(_that);case InspirationInputUsed():
return used(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InspirationInputEmpty value)?  empty,TResult? Function( InspirationInputTyped value)?  typed,TResult? Function( InspirationInputUsed value)?  used,}){
final _that = this;
switch (_that) {
case InspirationInputEmpty() when empty != null:
return empty(_that);case InspirationInputTyped() when typed != null:
return typed(_that);case InspirationInputUsed() when used != null:
return used(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function( String text,  int wordLimit)?  typed,TResult Function( String suggestionId,  String text,  int wordLimit)?  used,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InspirationInputEmpty() when empty != null:
return empty();case InspirationInputTyped() when typed != null:
return typed(_that.text,_that.wordLimit);case InspirationInputUsed() when used != null:
return used(_that.suggestionId,_that.text,_that.wordLimit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function( String text,  int wordLimit)  typed,required TResult Function( String suggestionId,  String text,  int wordLimit)  used,}) {final _that = this;
switch (_that) {
case InspirationInputEmpty():
return empty();case InspirationInputTyped():
return typed(_that.text,_that.wordLimit);case InspirationInputUsed():
return used(_that.suggestionId,_that.text,_that.wordLimit);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function( String text,  int wordLimit)?  typed,TResult? Function( String suggestionId,  String text,  int wordLimit)?  used,}) {final _that = this;
switch (_that) {
case InspirationInputEmpty() when empty != null:
return empty();case InspirationInputTyped() when typed != null:
return typed(_that.text,_that.wordLimit);case InspirationInputUsed() when used != null:
return used(_that.suggestionId,_that.text,_that.wordLimit);case _:
  return null;

}
}

}

/// @nodoc


class InspirationInputEmpty implements InspirationInputState {
  const InspirationInputEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InspirationInputEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InspirationInputState.empty()';
}


}




/// @nodoc


class InspirationInputTyped implements InspirationInputState {
  const InspirationInputTyped({required this.text, required this.wordLimit});
  

 final  String text;
 final  int wordLimit;

/// Create a copy of InspirationInputState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InspirationInputTypedCopyWith<InspirationInputTyped> get copyWith => _$InspirationInputTypedCopyWithImpl<InspirationInputTyped>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InspirationInputTyped&&(identical(other.text, text) || other.text == text)&&(identical(other.wordLimit, wordLimit) || other.wordLimit == wordLimit));
}


@override
int get hashCode => Object.hash(runtimeType,text,wordLimit);

@override
String toString() {
  return 'InspirationInputState.typed(text: $text, wordLimit: $wordLimit)';
}


}

/// @nodoc
abstract mixin class $InspirationInputTypedCopyWith<$Res> implements $InspirationInputStateCopyWith<$Res> {
  factory $InspirationInputTypedCopyWith(InspirationInputTyped value, $Res Function(InspirationInputTyped) _then) = _$InspirationInputTypedCopyWithImpl;
@useResult
$Res call({
 String text, int wordLimit
});




}
/// @nodoc
class _$InspirationInputTypedCopyWithImpl<$Res>
    implements $InspirationInputTypedCopyWith<$Res> {
  _$InspirationInputTypedCopyWithImpl(this._self, this._then);

  final InspirationInputTyped _self;
  final $Res Function(InspirationInputTyped) _then;

/// Create a copy of InspirationInputState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,Object? wordLimit = null,}) {
  return _then(InspirationInputTyped(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,wordLimit: null == wordLimit ? _self.wordLimit : wordLimit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class InspirationInputUsed implements InspirationInputState {
  const InspirationInputUsed({required this.suggestionId, required this.text, required this.wordLimit});
  

 final  String suggestionId;
 final  String text;
 final  int wordLimit;

/// Create a copy of InspirationInputState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InspirationInputUsedCopyWith<InspirationInputUsed> get copyWith => _$InspirationInputUsedCopyWithImpl<InspirationInputUsed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InspirationInputUsed&&(identical(other.suggestionId, suggestionId) || other.suggestionId == suggestionId)&&(identical(other.text, text) || other.text == text)&&(identical(other.wordLimit, wordLimit) || other.wordLimit == wordLimit));
}


@override
int get hashCode => Object.hash(runtimeType,suggestionId,text,wordLimit);

@override
String toString() {
  return 'InspirationInputState.used(suggestionId: $suggestionId, text: $text, wordLimit: $wordLimit)';
}


}

/// @nodoc
abstract mixin class $InspirationInputUsedCopyWith<$Res> implements $InspirationInputStateCopyWith<$Res> {
  factory $InspirationInputUsedCopyWith(InspirationInputUsed value, $Res Function(InspirationInputUsed) _then) = _$InspirationInputUsedCopyWithImpl;
@useResult
$Res call({
 String suggestionId, String text, int wordLimit
});




}
/// @nodoc
class _$InspirationInputUsedCopyWithImpl<$Res>
    implements $InspirationInputUsedCopyWith<$Res> {
  _$InspirationInputUsedCopyWithImpl(this._self, this._then);

  final InspirationInputUsed _self;
  final $Res Function(InspirationInputUsed) _then;

/// Create a copy of InspirationInputState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? suggestionId = null,Object? text = null,Object? wordLimit = null,}) {
  return _then(InspirationInputUsed(
suggestionId: null == suggestionId ? _self.suggestionId : suggestionId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,wordLimit: null == wordLimit ? _self.wordLimit : wordLimit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ProfileStudioData {

 InspirationInputState get inspiration; String get myStory; List<String> get interests; List<Narrative> get narratives; List<String> get joinMeFor; ProfileTone get tone;
/// Create a copy of ProfileStudioData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileStudioDataCopyWith<ProfileStudioData> get copyWith => _$ProfileStudioDataCopyWithImpl<ProfileStudioData>(this as ProfileStudioData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileStudioData&&(identical(other.inspiration, inspiration) || other.inspiration == inspiration)&&(identical(other.myStory, myStory) || other.myStory == myStory)&&const DeepCollectionEquality().equals(other.interests, interests)&&const DeepCollectionEquality().equals(other.narratives, narratives)&&const DeepCollectionEquality().equals(other.joinMeFor, joinMeFor)&&(identical(other.tone, tone) || other.tone == tone));
}


@override
int get hashCode => Object.hash(runtimeType,inspiration,myStory,const DeepCollectionEquality().hash(interests),const DeepCollectionEquality().hash(narratives),const DeepCollectionEquality().hash(joinMeFor),tone);

@override
String toString() {
  return 'ProfileStudioData(inspiration: $inspiration, myStory: $myStory, interests: $interests, narratives: $narratives, joinMeFor: $joinMeFor, tone: $tone)';
}


}

/// @nodoc
abstract mixin class $ProfileStudioDataCopyWith<$Res>  {
  factory $ProfileStudioDataCopyWith(ProfileStudioData value, $Res Function(ProfileStudioData) _then) = _$ProfileStudioDataCopyWithImpl;
@useResult
$Res call({
 InspirationInputState inspiration, String myStory, List<String> interests, List<Narrative> narratives, List<String> joinMeFor, ProfileTone tone
});


$InspirationInputStateCopyWith<$Res> get inspiration;

}
/// @nodoc
class _$ProfileStudioDataCopyWithImpl<$Res>
    implements $ProfileStudioDataCopyWith<$Res> {
  _$ProfileStudioDataCopyWithImpl(this._self, this._then);

  final ProfileStudioData _self;
  final $Res Function(ProfileStudioData) _then;

/// Create a copy of ProfileStudioData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inspiration = null,Object? myStory = null,Object? interests = null,Object? narratives = null,Object? joinMeFor = null,Object? tone = null,}) {
  return _then(_self.copyWith(
inspiration: null == inspiration ? _self.inspiration : inspiration // ignore: cast_nullable_to_non_nullable
as InspirationInputState,myStory: null == myStory ? _self.myStory : myStory // ignore: cast_nullable_to_non_nullable
as String,interests: null == interests ? _self.interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,narratives: null == narratives ? _self.narratives : narratives // ignore: cast_nullable_to_non_nullable
as List<Narrative>,joinMeFor: null == joinMeFor ? _self.joinMeFor : joinMeFor // ignore: cast_nullable_to_non_nullable
as List<String>,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as ProfileTone,
  ));
}
/// Create a copy of ProfileStudioData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InspirationInputStateCopyWith<$Res> get inspiration {
  
  return $InspirationInputStateCopyWith<$Res>(_self.inspiration, (value) {
    return _then(_self.copyWith(inspiration: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProfileStudioData].
extension ProfileStudioDataPatterns on ProfileStudioData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileStudioData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileStudioData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileStudioData value)  $default,){
final _that = this;
switch (_that) {
case _ProfileStudioData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileStudioData value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileStudioData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( InspirationInputState inspiration,  String myStory,  List<String> interests,  List<Narrative> narratives,  List<String> joinMeFor,  ProfileTone tone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileStudioData() when $default != null:
return $default(_that.inspiration,_that.myStory,_that.interests,_that.narratives,_that.joinMeFor,_that.tone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( InspirationInputState inspiration,  String myStory,  List<String> interests,  List<Narrative> narratives,  List<String> joinMeFor,  ProfileTone tone)  $default,) {final _that = this;
switch (_that) {
case _ProfileStudioData():
return $default(_that.inspiration,_that.myStory,_that.interests,_that.narratives,_that.joinMeFor,_that.tone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( InspirationInputState inspiration,  String myStory,  List<String> interests,  List<Narrative> narratives,  List<String> joinMeFor,  ProfileTone tone)?  $default,) {final _that = this;
switch (_that) {
case _ProfileStudioData() when $default != null:
return $default(_that.inspiration,_that.myStory,_that.interests,_that.narratives,_that.joinMeFor,_that.tone);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileStudioData implements ProfileStudioData {
  const _ProfileStudioData({this.inspiration = const InspirationInputState.empty(), this.myStory = '', final  List<String> interests = const <String>[], final  List<Narrative> narratives = const <Narrative>[], final  List<String> joinMeFor = const <String>[], this.tone = ProfileTone.natural}): _interests = interests,_narratives = narratives,_joinMeFor = joinMeFor;
  

@override@JsonKey() final  InspirationInputState inspiration;
@override@JsonKey() final  String myStory;
 final  List<String> _interests;
@override@JsonKey() List<String> get interests {
  if (_interests is EqualUnmodifiableListView) return _interests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_interests);
}

 final  List<Narrative> _narratives;
@override@JsonKey() List<Narrative> get narratives {
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

@override@JsonKey() final  ProfileTone tone;

/// Create a copy of ProfileStudioData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileStudioDataCopyWith<_ProfileStudioData> get copyWith => __$ProfileStudioDataCopyWithImpl<_ProfileStudioData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileStudioData&&(identical(other.inspiration, inspiration) || other.inspiration == inspiration)&&(identical(other.myStory, myStory) || other.myStory == myStory)&&const DeepCollectionEquality().equals(other._interests, _interests)&&const DeepCollectionEquality().equals(other._narratives, _narratives)&&const DeepCollectionEquality().equals(other._joinMeFor, _joinMeFor)&&(identical(other.tone, tone) || other.tone == tone));
}


@override
int get hashCode => Object.hash(runtimeType,inspiration,myStory,const DeepCollectionEquality().hash(_interests),const DeepCollectionEquality().hash(_narratives),const DeepCollectionEquality().hash(_joinMeFor),tone);

@override
String toString() {
  return 'ProfileStudioData(inspiration: $inspiration, myStory: $myStory, interests: $interests, narratives: $narratives, joinMeFor: $joinMeFor, tone: $tone)';
}


}

/// @nodoc
abstract mixin class _$ProfileStudioDataCopyWith<$Res> implements $ProfileStudioDataCopyWith<$Res> {
  factory _$ProfileStudioDataCopyWith(_ProfileStudioData value, $Res Function(_ProfileStudioData) _then) = __$ProfileStudioDataCopyWithImpl;
@override @useResult
$Res call({
 InspirationInputState inspiration, String myStory, List<String> interests, List<Narrative> narratives, List<String> joinMeFor, ProfileTone tone
});


@override $InspirationInputStateCopyWith<$Res> get inspiration;

}
/// @nodoc
class __$ProfileStudioDataCopyWithImpl<$Res>
    implements _$ProfileStudioDataCopyWith<$Res> {
  __$ProfileStudioDataCopyWithImpl(this._self, this._then);

  final _ProfileStudioData _self;
  final $Res Function(_ProfileStudioData) _then;

/// Create a copy of ProfileStudioData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inspiration = null,Object? myStory = null,Object? interests = null,Object? narratives = null,Object? joinMeFor = null,Object? tone = null,}) {
  return _then(_ProfileStudioData(
inspiration: null == inspiration ? _self.inspiration : inspiration // ignore: cast_nullable_to_non_nullable
as InspirationInputState,myStory: null == myStory ? _self.myStory : myStory // ignore: cast_nullable_to_non_nullable
as String,interests: null == interests ? _self._interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,narratives: null == narratives ? _self._narratives : narratives // ignore: cast_nullable_to_non_nullable
as List<Narrative>,joinMeFor: null == joinMeFor ? _self._joinMeFor : joinMeFor // ignore: cast_nullable_to_non_nullable
as List<String>,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as ProfileTone,
  ));
}

/// Create a copy of ProfileStudioData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InspirationInputStateCopyWith<$Res> get inspiration {
  
  return $InspirationInputStateCopyWith<$Res>(_self.inspiration, (value) {
    return _then(_self.copyWith(inspiration: value));
  });
}
}

// dart format on
