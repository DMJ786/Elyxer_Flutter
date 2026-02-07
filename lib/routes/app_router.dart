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
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/verification_flow_screen.dart';
import '../screens/debug/next_button_debug_screen.dart';

/// App router instance
final appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    // Route 1: Verification Flow (Initial screen - with animations)
    GoRoute(
      path: '/',
      name: 'verification-flow',
      builder: (context, state) => const VerificationFlowScreen(),
    ),

    // Legacy Route: Phone Input Screen (standalone, for testing)
    GoRoute(
      path: '/phone-input-standalone',
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

    // Route 3: Onboarding Flow (Age, Gender, Pronoun)
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // Route 4: Username Input
    GoRoute(
      path: '/username',
      name: 'username',
      builder: (context, state) => const UsernameScreen(),
    ),

    // Route 5: Email Input
    GoRoute(
      path: '/email-input',
      name: 'email-input',
      builder: (context, state) => const EmailInputScreen(),
    ),

    // Route 6: Email OTP Verification
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

    // Route 7: Completion Screen
    GoRoute(
      path: '/complete',
      name: 'complete',
      builder: (context, state) => const CompleteScreen(),
    ),

    // Debug Route: NextButton Debug Screen
    GoRoute(
      path: '/debug/next-button',
      name: 'next-button-debug',
      builder: (context, state) => const NextButtonDebugScreen(),
    ),
  ],

  // Error handling
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Error: ${state.error}'),
    ),
  ),
);
