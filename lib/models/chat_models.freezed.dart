// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatUser {

 String get id; String get name; String? get avatarUrl; bool get isOnline;
/// Create a copy of ChatUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatUserCopyWith<ChatUser> get copyWith => _$ChatUserCopyWithImpl<ChatUser>(this as ChatUser, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatUser&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,avatarUrl,isOnline);

@override
String toString() {
  return 'ChatUser(id: $id, name: $name, avatarUrl: $avatarUrl, isOnline: $isOnline)';
}


}

/// @nodoc
abstract mixin class $ChatUserCopyWith<$Res>  {
  factory $ChatUserCopyWith(ChatUser value, $Res Function(ChatUser) _then) = _$ChatUserCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? avatarUrl, bool isOnline
});




}
/// @nodoc
class _$ChatUserCopyWithImpl<$Res>
    implements $ChatUserCopyWith<$Res> {
  _$ChatUserCopyWithImpl(this._self, this._then);

  final ChatUser _self;
  final $Res Function(ChatUser) _then;

/// Create a copy of ChatUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? avatarUrl = freezed,Object? isOnline = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatUser].
extension ChatUserPatterns on ChatUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatUser value)  $default,){
final _that = this;
switch (_that) {
case _ChatUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatUser value)?  $default,){
final _that = this;
switch (_that) {
case _ChatUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? avatarUrl,  bool isOnline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatUser() when $default != null:
return $default(_that.id,_that.name,_that.avatarUrl,_that.isOnline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? avatarUrl,  bool isOnline)  $default,) {final _that = this;
switch (_that) {
case _ChatUser():
return $default(_that.id,_that.name,_that.avatarUrl,_that.isOnline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? avatarUrl,  bool isOnline)?  $default,) {final _that = this;
switch (_that) {
case _ChatUser() when $default != null:
return $default(_that.id,_that.name,_that.avatarUrl,_that.isOnline);case _:
  return null;

}
}

}

/// @nodoc


class _ChatUser implements ChatUser {
  const _ChatUser({required this.id, required this.name, this.avatarUrl, this.isOnline = false});
  

@override final  String id;
@override final  String name;
@override final  String? avatarUrl;
@override@JsonKey() final  bool isOnline;

/// Create a copy of ChatUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatUserCopyWith<_ChatUser> get copyWith => __$ChatUserCopyWithImpl<_ChatUser>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatUser&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,avatarUrl,isOnline);

@override
String toString() {
  return 'ChatUser(id: $id, name: $name, avatarUrl: $avatarUrl, isOnline: $isOnline)';
}


}

/// @nodoc
abstract mixin class _$ChatUserCopyWith<$Res> implements $ChatUserCopyWith<$Res> {
  factory _$ChatUserCopyWith(_ChatUser value, $Res Function(_ChatUser) _then) = __$ChatUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? avatarUrl, bool isOnline
});




}
/// @nodoc
class __$ChatUserCopyWithImpl<$Res>
    implements _$ChatUserCopyWith<$Res> {
  __$ChatUserCopyWithImpl(this._self, this._then);

  final _ChatUser _self;
  final $Res Function(_ChatUser) _then;

/// Create a copy of ChatUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? avatarUrl = freezed,Object? isOnline = null,}) {
  return _then(_ChatUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$ChatMessage {

 String get id; String get channelUrl; String get senderId; String get text; DateTime get sentAt; ChatMessageType get type; ChatMessageStatus get status;/// Decoded custom payload for non-text types (e.g. the Virtual Date
/// invite's state + invitee name). Null for plain text.
 Map<String, Object?>? get data;
/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageCopyWith<ChatMessage> get copyWith => _$ChatMessageCopyWithImpl<ChatMessage>(this as ChatMessage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.channelUrl, channelUrl) || other.channelUrl == channelUrl)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.text, text) || other.text == text)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,id,channelUrl,senderId,text,sentAt,type,status,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'ChatMessage(id: $id, channelUrl: $channelUrl, senderId: $senderId, text: $text, sentAt: $sentAt, type: $type, status: $status, data: $data)';
}


}

/// @nodoc
abstract mixin class $ChatMessageCopyWith<$Res>  {
  factory $ChatMessageCopyWith(ChatMessage value, $Res Function(ChatMessage) _then) = _$ChatMessageCopyWithImpl;
@useResult
$Res call({
 String id, String channelUrl, String senderId, String text, DateTime sentAt, ChatMessageType type, ChatMessageStatus status, Map<String, Object?>? data
});




}
/// @nodoc
class _$ChatMessageCopyWithImpl<$Res>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._self, this._then);

  final ChatMessage _self;
  final $Res Function(ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? channelUrl = null,Object? senderId = null,Object? text = null,Object? sentAt = null,Object? type = null,Object? status = null,Object? data = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,channelUrl: null == channelUrl ? _self.channelUrl : channelUrl // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,sentAt: null == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ChatMessageType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ChatMessageStatus,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessage].
extension ChatMessagePatterns on ChatMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessage value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String channelUrl,  String senderId,  String text,  DateTime sentAt,  ChatMessageType type,  ChatMessageStatus status,  Map<String, Object?>? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.channelUrl,_that.senderId,_that.text,_that.sentAt,_that.type,_that.status,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String channelUrl,  String senderId,  String text,  DateTime sentAt,  ChatMessageType type,  ChatMessageStatus status,  Map<String, Object?>? data)  $default,) {final _that = this;
switch (_that) {
case _ChatMessage():
return $default(_that.id,_that.channelUrl,_that.senderId,_that.text,_that.sentAt,_that.type,_that.status,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String channelUrl,  String senderId,  String text,  DateTime sentAt,  ChatMessageType type,  ChatMessageStatus status,  Map<String, Object?>? data)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.channelUrl,_that.senderId,_that.text,_that.sentAt,_that.type,_that.status,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _ChatMessage extends ChatMessage {
  const _ChatMessage({required this.id, required this.channelUrl, required this.senderId, required this.text, required this.sentAt, this.type = ChatMessageType.text, this.status = ChatMessageStatus.sent, final  Map<String, Object?>? data}): _data = data,super._();
  

@override final  String id;
@override final  String channelUrl;
@override final  String senderId;
@override final  String text;
@override final  DateTime sentAt;
@override@JsonKey() final  ChatMessageType type;
@override@JsonKey() final  ChatMessageStatus status;
/// Decoded custom payload for non-text types (e.g. the Virtual Date
/// invite's state + invitee name). Null for plain text.
 final  Map<String, Object?>? _data;
/// Decoded custom payload for non-text types (e.g. the Virtual Date
/// invite's state + invitee name). Null for plain text.
@override Map<String, Object?>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageCopyWith<_ChatMessage> get copyWith => __$ChatMessageCopyWithImpl<_ChatMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.channelUrl, channelUrl) || other.channelUrl == channelUrl)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.text, text) || other.text == text)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,id,channelUrl,senderId,text,sentAt,type,status,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'ChatMessage(id: $id, channelUrl: $channelUrl, senderId: $senderId, text: $text, sentAt: $sentAt, type: $type, status: $status, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageCopyWith<$Res> implements $ChatMessageCopyWith<$Res> {
  factory _$ChatMessageCopyWith(_ChatMessage value, $Res Function(_ChatMessage) _then) = __$ChatMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String channelUrl, String senderId, String text, DateTime sentAt, ChatMessageType type, ChatMessageStatus status, Map<String, Object?>? data
});




}
/// @nodoc
class __$ChatMessageCopyWithImpl<$Res>
    implements _$ChatMessageCopyWith<$Res> {
  __$ChatMessageCopyWithImpl(this._self, this._then);

  final _ChatMessage _self;
  final $Res Function(_ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? channelUrl = null,Object? senderId = null,Object? text = null,Object? sentAt = null,Object? type = null,Object? status = null,Object? data = freezed,}) {
  return _then(_ChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,channelUrl: null == channelUrl ? _self.channelUrl : channelUrl // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,sentAt: null == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ChatMessageType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ChatMessageStatus,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,
  ));
}


}

/// @nodoc
mixin _$ChatChannel {

/// Sendbird channel URL — the stable id for the conversation.
 String get url; ChatUser get otherUser; ChatMessage? get lastMessage; int get unreadCount; DateTime? get lastActivityAt;
/// Create a copy of ChatChannel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatChannelCopyWith<ChatChannel> get copyWith => _$ChatChannelCopyWithImpl<ChatChannel>(this as ChatChannel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatChannel&&(identical(other.url, url) || other.url == url)&&(identical(other.otherUser, otherUser) || other.otherUser == otherUser)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.lastActivityAt, lastActivityAt) || other.lastActivityAt == lastActivityAt));
}


@override
int get hashCode => Object.hash(runtimeType,url,otherUser,lastMessage,unreadCount,lastActivityAt);

@override
String toString() {
  return 'ChatChannel(url: $url, otherUser: $otherUser, lastMessage: $lastMessage, unreadCount: $unreadCount, lastActivityAt: $lastActivityAt)';
}


}

/// @nodoc
abstract mixin class $ChatChannelCopyWith<$Res>  {
  factory $ChatChannelCopyWith(ChatChannel value, $Res Function(ChatChannel) _then) = _$ChatChannelCopyWithImpl;
@useResult
$Res call({
 String url, ChatUser otherUser, ChatMessage? lastMessage, int unreadCount, DateTime? lastActivityAt
});


$ChatUserCopyWith<$Res> get otherUser;$ChatMessageCopyWith<$Res>? get lastMessage;

}
/// @nodoc
class _$ChatChannelCopyWithImpl<$Res>
    implements $ChatChannelCopyWith<$Res> {
  _$ChatChannelCopyWithImpl(this._self, this._then);

  final ChatChannel _self;
  final $Res Function(ChatChannel) _then;

/// Create a copy of ChatChannel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? otherUser = null,Object? lastMessage = freezed,Object? unreadCount = null,Object? lastActivityAt = freezed,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,otherUser: null == otherUser ? _self.otherUser : otherUser // ignore: cast_nullable_to_non_nullable
as ChatUser,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as ChatMessage?,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,lastActivityAt: freezed == lastActivityAt ? _self.lastActivityAt : lastActivityAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of ChatChannel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatUserCopyWith<$Res> get otherUser {
  
  return $ChatUserCopyWith<$Res>(_self.otherUser, (value) {
    return _then(_self.copyWith(otherUser: value));
  });
}/// Create a copy of ChatChannel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatMessageCopyWith<$Res>? get lastMessage {
    if (_self.lastMessage == null) {
    return null;
  }

  return $ChatMessageCopyWith<$Res>(_self.lastMessage!, (value) {
    return _then(_self.copyWith(lastMessage: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChatChannel].
extension ChatChannelPatterns on ChatChannel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatChannel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatChannel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatChannel value)  $default,){
final _that = this;
switch (_that) {
case _ChatChannel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatChannel value)?  $default,){
final _that = this;
switch (_that) {
case _ChatChannel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  ChatUser otherUser,  ChatMessage? lastMessage,  int unreadCount,  DateTime? lastActivityAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatChannel() when $default != null:
return $default(_that.url,_that.otherUser,_that.lastMessage,_that.unreadCount,_that.lastActivityAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  ChatUser otherUser,  ChatMessage? lastMessage,  int unreadCount,  DateTime? lastActivityAt)  $default,) {final _that = this;
switch (_that) {
case _ChatChannel():
return $default(_that.url,_that.otherUser,_that.lastMessage,_that.unreadCount,_that.lastActivityAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  ChatUser otherUser,  ChatMessage? lastMessage,  int unreadCount,  DateTime? lastActivityAt)?  $default,) {final _that = this;
switch (_that) {
case _ChatChannel() when $default != null:
return $default(_that.url,_that.otherUser,_that.lastMessage,_that.unreadCount,_that.lastActivityAt);case _:
  return null;

}
}

}

/// @nodoc


class _ChatChannel implements ChatChannel {
  const _ChatChannel({required this.url, required this.otherUser, this.lastMessage, this.unreadCount = 0, this.lastActivityAt});
  

/// Sendbird channel URL — the stable id for the conversation.
@override final  String url;
@override final  ChatUser otherUser;
@override final  ChatMessage? lastMessage;
@override@JsonKey() final  int unreadCount;
@override final  DateTime? lastActivityAt;

/// Create a copy of ChatChannel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatChannelCopyWith<_ChatChannel> get copyWith => __$ChatChannelCopyWithImpl<_ChatChannel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatChannel&&(identical(other.url, url) || other.url == url)&&(identical(other.otherUser, otherUser) || other.otherUser == otherUser)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.lastActivityAt, lastActivityAt) || other.lastActivityAt == lastActivityAt));
}


@override
int get hashCode => Object.hash(runtimeType,url,otherUser,lastMessage,unreadCount,lastActivityAt);

@override
String toString() {
  return 'ChatChannel(url: $url, otherUser: $otherUser, lastMessage: $lastMessage, unreadCount: $unreadCount, lastActivityAt: $lastActivityAt)';
}


}

/// @nodoc
abstract mixin class _$ChatChannelCopyWith<$Res> implements $ChatChannelCopyWith<$Res> {
  factory _$ChatChannelCopyWith(_ChatChannel value, $Res Function(_ChatChannel) _then) = __$ChatChannelCopyWithImpl;
@override @useResult
$Res call({
 String url, ChatUser otherUser, ChatMessage? lastMessage, int unreadCount, DateTime? lastActivityAt
});


@override $ChatUserCopyWith<$Res> get otherUser;@override $ChatMessageCopyWith<$Res>? get lastMessage;

}
/// @nodoc
class __$ChatChannelCopyWithImpl<$Res>
    implements _$ChatChannelCopyWith<$Res> {
  __$ChatChannelCopyWithImpl(this._self, this._then);

  final _ChatChannel _self;
  final $Res Function(_ChatChannel) _then;

/// Create a copy of ChatChannel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? otherUser = null,Object? lastMessage = freezed,Object? unreadCount = null,Object? lastActivityAt = freezed,}) {
  return _then(_ChatChannel(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,otherUser: null == otherUser ? _self.otherUser : otherUser // ignore: cast_nullable_to_non_nullable
as ChatUser,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as ChatMessage?,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,lastActivityAt: freezed == lastActivityAt ? _self.lastActivityAt : lastActivityAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of ChatChannel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatUserCopyWith<$Res> get otherUser {
  
  return $ChatUserCopyWith<$Res>(_self.otherUser, (value) {
    return _then(_self.copyWith(otherUser: value));
  });
}/// Create a copy of ChatChannel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatMessageCopyWith<$Res>? get lastMessage {
    if (_self.lastMessage == null) {
    return null;
  }

  return $ChatMessageCopyWith<$Res>(_self.lastMessage!, (value) {
    return _then(_self.copyWith(lastMessage: value));
  });
}
}

// dart format on
