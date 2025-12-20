/// Riverpod Providers for Verification Flow
/// Run: flutter pub run build_runner build --delete-conflicting-outputs
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/verification_models.dart';
import '../services/verification_service.dart';

part 'verification_provider.g.dart';

/// Verification Service Provider
@riverpod
VerificationService verificationService(Ref ref) {
  return VerificationService();
}

/// Verification Data State Provider
final verificationDataProvider =
    StateProvider<VerificationData?>((ref) => null);

/// Phone Input Provider
final phoneInputProvider = StateProvider<PhoneInputData?>((ref) => null);

/// Username Provider
final usernameProvider = StateProvider<UsernameData?>((ref) => null);

/// Email Input Provider
final emailInputProvider = StateProvider<EmailInputData?>((ref) => null);

/// OTP Timer Provider (for phone verification)
@riverpod
class PhoneOTPTimer extends _$PhoneOTPTimer {
  @override
  OTPTimerState build() {
    return const OTPTimerState(
      timeLeft: 120,
      isExpired: false,
      canResend: false,
    );
  }

  void start() {
    _startTimer();
  }

  void reset() {
    state = const OTPTimerState(
      timeLeft: 120,
      isExpired: false,
      canResend: false,
    );
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (state.timeLeft > 0) {
        state = OTPTimerState(
          timeLeft: state.timeLeft - 1,
          isExpired: state.timeLeft - 1 == 0,
          canResend: state.timeLeft - 1 == 0,
        );
        _startTimer();
      }
    });
  }
}

/// OTP Timer Provider (for email verification)
@riverpod
class EmailOTPTimer extends _$EmailOTPTimer {
  @override
  OTPTimerState build() {
    return const OTPTimerState(
      timeLeft: 120,
      isExpired: false,
      canResend: false,
    );
  }

  void start() {
    _startTimer();
  }

  void reset() {
    state = const OTPTimerState(
      timeLeft: 120,
      isExpired: false,
      canResend: false,
    );
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (state.timeLeft > 0) {
        state = OTPTimerState(
          timeLeft: state.timeLeft - 1,
          isExpired: state.timeLeft - 1 == 0,
          canResend: state.timeLeft - 1 == 0,
        );
        _startTimer();
      }
    });
  }
}

/// Send Phone OTP Provider
@riverpod
Future<SendOTPResponse> sendPhoneOTP(
  Ref ref,
  PhoneInputData phoneData,
) async {
  final service = ref.read(verificationServiceProvider);
  return service.sendPhoneOTP(phoneData);
}

/// Verify Phone OTP Provider
@riverpod
Future<VerifyOTPResponse> verifyPhoneOTP(
  Ref ref,
  PhoneInputData phoneData,
  String code,
) async {
  final service = ref.read(verificationServiceProvider);
  return service.verifyPhoneOTP(phoneData, code);
}

/// Submit Username Provider
@riverpod
Future<bool> submitUsername(
  Ref ref,
  UsernameData usernameData,
) async {
  final service = ref.read(verificationServiceProvider);
  return service.submitUsername(usernameData);
}

/// Send Email OTP Provider
@riverpod
Future<SendOTPResponse> sendEmailOTP(
  Ref ref,
  String email,
) async {
  final service = ref.read(verificationServiceProvider);
  return service.sendEmailOTP(email);
}

/// Verify Email OTP Provider
@riverpod
Future<VerifyOTPResponse> verifyEmailOTP(
  Ref ref,
  String email,
  String code,
) async {
  final service = ref.read(verificationServiceProvider);
  return service.verifyEmailOTP(email, code);
}

/// Submit Email Preferences Provider
@riverpod
Future<bool> submitEmailPreferences(
  Ref ref,
  EmailInputData emailData,
) async {
  final service = ref.read(verificationServiceProvider);
  return service.submitEmailPreferences(emailData);
}
