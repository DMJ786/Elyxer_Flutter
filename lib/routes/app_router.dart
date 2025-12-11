/// App Router Configuration using go_router
/// Defines all navigation routes for the verification flow
library;

import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../screens/phone_input_screen.dart';
import '../screens/phone_otp_screen.dart';
import '../screens/username_screen.dart';
import '../screens/email_input_screen.dart';
import '../screens/email_otp_screen.dart';
import '../screens/complete_screen.dart';

/// App router instance
final appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    // Route 1: Phone Input Screen (Initial screen)
    GoRoute(
      path: '/',
      name: 'phone-input',
      builder: (context, state) => const PhoneInputScreen(),
    ),

    // Route 2: Phone OTP Verification
    GoRoute(
      path: '/phone-otp',
      name: 'phone-otp',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return PhoneOTPScreen(
          phoneNumber: extra?['phoneNumber'] as String? ?? '',
          countryCode: extra?['countryCode'] as String? ?? '+1',
        );
      },
    ),

    // Route 3: Username Input
    GoRoute(
      path: '/username',
      name: 'username',
      builder: (context, state) => const UsernameScreen(),
    ),

    // Route 4: Email Input
    GoRoute(
      path: '/email',
      name: 'email',
      builder: (context, state) => const EmailInputScreen(),
    ),

    // Route 5: Email OTP Verification
    GoRoute(
      path: '/email-otp',
      name: 'email-otp',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return EmailOTPScreen(
          email: extra?['email'] as String? ?? '',
        );
      },
    ),

    // Route 6: Completion Screen
    GoRoute(
      path: '/complete',
      name: 'complete',
      builder: (context, state) => const CompleteScreen(),
    ),
  ],

  // Error handling
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Error: ${state.error}'),
    ),
  ),
);
