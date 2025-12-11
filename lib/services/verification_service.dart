/// Verification API Service
/// Replace with actual API calls to your backend
library;

import '../models/verification_models.dart';

class VerificationService {
  // TODO: Replace with your actual API base URL
  static const String apiBaseUrl = 'https://your-api-endpoint.com/api';

  /// Send OTP to phone number
  Future<SendOTPResponse> sendPhoneOTP(PhoneInputData phoneData) async {
    try {
      // TODO: Replace with actual API call using dio
      // final response = await dio.post('/auth/send-phone-otp', data: {
      //   'countryCode': phoneData.countryCode,
      //   'phoneNumber': phoneData.phoneNumber,
      // });

      // Mock response for development
      await Future.delayed(const Duration(seconds: 1));
      return SendOTPResponse(
        success: true,
        expiresAt: DateTime.now().add(const Duration(minutes: 2)).toIso8601String(),
        message: 'OTP sent successfully',
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Verify phone OTP
  Future<VerifyOTPResponse> verifyPhoneOTP(
    PhoneInputData phoneData,
    String code,
  ) async {
    try {
      // TODO: Replace with actual API call
      // final response = await dio.post('/auth/verify-phone-otp', data: {
      //   'countryCode': phoneData.countryCode,
      //   'phoneNumber': phoneData.phoneNumber,
      //   'code': code,
      // });

      // Mock response for development
      await Future.delayed(const Duration(seconds: 1));
      return const VerifyOTPResponse(
        success: true,
        token: 'mock-jwt-token',
        message: 'Phone verified successfully',
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Submit username
  Future<bool> submitUsername(UsernameData usernameData) async {
    try {
      // TODO: Replace with actual API call
      // final response = await dio.post('/auth/username', data: {
      //   'firstName': usernameData.firstName,
      //   'lastName': usernameData.lastName,
      // });

      // Mock response for development
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      rethrow;
    }
  }

  /// Send OTP to email
  Future<SendOTPResponse> sendEmailOTP(String email) async {
    try {
      // TODO: Replace with actual API call
      // final response = await dio.post('/auth/send-email-otp', data: {
      //   'email': email,
      // });

      // Mock response for development
      await Future.delayed(const Duration(seconds: 1));
      return SendOTPResponse(
        success: true,
        expiresAt: DateTime.now().add(const Duration(minutes: 2)).toIso8601String(),
        message: 'OTP sent to email',
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Verify email OTP
  Future<VerifyOTPResponse> verifyEmailOTP(String email, String code) async {
    try {
      // TODO: Replace with actual API call
      // final response = await dio.post('/auth/verify-email-otp', data: {
      //   'email': email,
      //   'code': code,
      // });

      // Mock response for development
      await Future.delayed(const Duration(seconds: 1));
      return const VerifyOTPResponse(
        success: true,
        token: 'mock-jwt-token',
        message: 'Email verified successfully',
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Submit email preferences
  Future<bool> submitEmailPreferences(EmailInputData emailData) async {
    try {
      // TODO: Replace with actual API call
      // final response = await dio.post('/auth/email-preferences', data: {
      //   'email': emailData.email,
      //   'enableNotifications': emailData.enableNotifications,
      // });

      // Mock response for development
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
