// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PhoneInputData _$PhoneInputDataFromJson(Map<String, dynamic> json) =>
    _PhoneInputData(
      countryCode: json['countryCode'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );

Map<String, dynamic> _$PhoneInputDataToJson(_PhoneInputData instance) =>
    <String, dynamic>{
      'countryCode': instance.countryCode,
      'phoneNumber': instance.phoneNumber,
    };

_OTPData _$OTPDataFromJson(Map<String, dynamic> json) => _OTPData(
  code: json['code'] as String,
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$OTPDataToJson(_OTPData instance) => <String, dynamic>{
  'code': instance.code,
  'expiresAt': instance.expiresAt?.toIso8601String(),
};

_UsernameData _$UsernameDataFromJson(Map<String, dynamic> json) =>
    _UsernameData(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String?,
    );

Map<String, dynamic> _$UsernameDataToJson(_UsernameData instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };

_EmailInputData _$EmailInputDataFromJson(Map<String, dynamic> json) =>
    _EmailInputData(
      email: json['email'] as String,
      enableNotifications: json['enableNotifications'] as bool? ?? false,
    );

Map<String, dynamic> _$EmailInputDataToJson(_EmailInputData instance) =>
    <String, dynamic>{
      'email': instance.email,
      'enableNotifications': instance.enableNotifications,
    };

_VerificationData _$VerificationDataFromJson(Map<String, dynamic> json) =>
    _VerificationData(
      phone: PhoneInputData.fromJson(json['phone'] as Map<String, dynamic>),
      phoneVerified: json['phoneVerified'] as bool? ?? false,
      username: UsernameData.fromJson(json['username'] as Map<String, dynamic>),
      email: json['email'] == null
          ? null
          : EmailInputData.fromJson(json['email'] as Map<String, dynamic>),
      emailVerified: json['emailVerified'] as bool? ?? false,
      emailSkipped: json['emailSkipped'] as bool? ?? false,
    );

Map<String, dynamic> _$VerificationDataToJson(_VerificationData instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'phoneVerified': instance.phoneVerified,
      'username': instance.username,
      'email': instance.email,
      'emailVerified': instance.emailVerified,
      'emailSkipped': instance.emailSkipped,
    };

_SendOTPResponse _$SendOTPResponseFromJson(Map<String, dynamic> json) =>
    _SendOTPResponse(
      success: json['success'] as bool,
      expiresAt: json['expiresAt'] as String,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$SendOTPResponseToJson(_SendOTPResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'expiresAt': instance.expiresAt,
      'message': instance.message,
    };

_VerifyOTPResponse _$VerifyOTPResponseFromJson(Map<String, dynamic> json) =>
    _VerifyOTPResponse(
      success: json['success'] as bool,
      token: json['token'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$VerifyOTPResponseToJson(_VerifyOTPResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'token': instance.token,
      'message': instance.message,
    };
