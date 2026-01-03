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

/// Custom page transition that animates only content, not progress bar
/// Mimics Figma's Smart Animate behavior
CustomTransitionPage<T> buildContentTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Smoother curve for better slide feel
      const curve = Curves.easeInOutCubic;
      
      // Incoming screen animation (slide + fade in)
      final slideAnimation = Tween<Offset>(
        begin: const Offset(1.0, 0.0), // Enter from right
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: curve,
        ),
      );

      final fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: curve,
        ),
      );

      return SlideTransition(
        position: slideAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 450),
    reverseTransitionDuration: const Duration(milliseconds: 450),
  );
}

/// App router instance
final appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    // Route 1: Phone Input Screen (Initial screen)
    GoRoute(
      path: '/',
      name: 'phone-input',
      pageBuilder: (context, state) => buildContentTransition(
        context: context,
        state: state,
        child: const PhoneInputScreen(),
      ),
    ),

    // Route 2: Phone OTP Verification
    GoRoute(
      path: '/phone-otp',
      name: 'phone-otp',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return buildContentTransition(
          context: context,
          state: state,
          child: PhoneOTPScreen(
            phoneNumber: extra?['phoneNumber'] as String? ?? '',
            countryCode: extra?['countryCode'] as String? ?? '+1',
          ),
        );
      },
    ),

    // Route 3: Username Input
    GoRoute(
      path: '/username',
      name: 'username',
      pageBuilder: (context, state) => buildContentTransition(
        context: context,
        state: state,
        child: const UsernameScreen(),
      ),
    ),

    // Route 4: Email Input
    GoRoute(
      path: '/email',
      name: 'email',
      pageBuilder: (context, state) => buildContentTransition(
        context: context,
        state: state,
        child: const EmailInputScreen(),
      ),
    ),

    // Route 5: Email OTP Verification
    GoRoute(
      path: '/email-otp',
      name: 'email-otp',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return buildContentTransition(
          context: context,
          state: state,
          child: EmailOTPScreen(
            email: extra?['email'] as String? ?? '',
          ),
        );
      },
    ),

    // Route 6: Completion Screen
    GoRoute(
      path: '/complete',
      name: 'complete',
      pageBuilder: (context, state) => buildContentTransition(
        context: context,
        state: state,
        child: const CompleteScreen(),
      ),
    ),
  ],

  // Error handling
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Error: ${state.error}'),
    ),
  ),
);
