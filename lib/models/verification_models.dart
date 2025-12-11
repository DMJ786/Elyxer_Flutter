/// Freezed Models for Verification Flow
/// Run: flutter pub run build_runner build --delete-conflicting-outputs
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_models.freezed.dart';
part 'verification_models.g.dart';

/// Phone input data
@freezed
class PhoneInputData with _$PhoneInputData {
  const factory PhoneInputData({
    required String countryCode,
    required String phoneNumber,
  }) = _PhoneInputData;

  factory PhoneInputData.fromJson(Map<String, dynamic> json) =>
      _$PhoneInputDataFromJson(json);
}

/// OTP data
@freezed
class OTPData with _$OTPData {
  const factory OTPData({
    required String code,
    DateTime? expiresAt,
  }) = _OTPData;

  factory OTPData.fromJson(Map<String, dynamic> json) =>
      _$OTPDataFromJson(json);
}

/// Username data
@freezed
class UsernameData with _$UsernameData {
  const factory UsernameData({
    required String firstName,
    String? lastName,
  }) = _UsernameData;

  factory UsernameData.fromJson(Map<String, dynamic> json) =>
      _$UsernameDataFromJson(json);
}

/// Email input data
@freezed
class EmailInputData with _$EmailInputData {
  const factory EmailInputData({
    required String email,
    @Default(false) bool enableNotifications,
  }) = _EmailInputData;

  factory EmailInputData.fromJson(Map<String, dynamic> json) =>
      _$EmailInputDataFromJson(json);
}

/// Complete verification data
@freezed
class VerificationData with _$VerificationData {
  const factory VerificationData({
    required PhoneInputData phone,
    @Default(false) bool phoneVerified,
    required UsernameData username,
    EmailInputData? email,
    @Default(false) bool emailVerified,
  }) = _VerificationData;

  factory VerificationData.fromJson(Map<String, dynamic> json) =>
      _$VerificationDataFromJson(json);
}

/// API Response for sending OTP
@freezed
class SendOTPResponse with _$SendOTPResponse {
  const factory SendOTPResponse({
    required bool success,
    required String expiresAt,
    String? message,
  }) = _SendOTPResponse;

  factory SendOTPResponse.fromJson(Map<String, dynamic> json) =>
      _$SendOTPResponseFromJson(json);
}

/// API Response for verifying OTP
@freezed
class VerifyOTPResponse with _$VerifyOTPResponse {
  const factory VerifyOTPResponse({
    required bool success,
    String? token,
    String? message,
  }) = _VerifyOTPResponse;

  factory VerifyOTPResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyOTPResponseFromJson(json);
}

/// Progress step status
enum StepStatus {
  incomplete,
  inProgress,
  completed,
}

/// Progress step model
@freezed
class ProgressStep with _$ProgressStep {
  const factory ProgressStep({
    required String id,
    required StepIcon icon,
    required StepStatus status,
  }) = _ProgressStep;
}

/// Step icon types
enum StepIcon {
  phone,
  account,
  mail,
  complete,
}

/// OTP Timer State
@freezed
class OTPTimerState with _$OTPTimerState {
  const factory OTPTimerState({
    required int timeLeft,
    required bool isExpired,
    required bool canResend,
  }) = _OTPTimerState;

  const OTPTimerState._();

  /// Format time as MM:SS
  String get formattedTime {
    final mins = timeLeft ~/ 60;
    final secs = timeLeft % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
