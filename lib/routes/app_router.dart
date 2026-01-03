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
      // Smart animate: Slide + Fade for smoother transitions
      const begin = Offset(1.0, 0.0); // Enter from right
      const end = Offset.zero;

      // Incoming screen animation (slide + fade in)
      final slideInAnimation = Tween<Offset>(
        begin: begin,
        end: end,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
      );

      final fadeInAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut, // Full duration fade in
        ),
      );

      // Outgoing screen animation (slide + fade out)
      final slideOutAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-0.3, 0.0), // Slight slide out (Smart animate style)
      ).animate(
        CurvedAnimation(
          parent: secondaryAnimation,
          curve: Curves.easeOut,
        ),
      );

      final fadeOutAnimation = Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(
        CurvedAnimation(
          parent: secondaryAnimation,
          curve: Curves.easeOut, // Full duration fade out
        ),
      );

      return Stack(
        children: [
          // Old content sliding out with fade
          if (secondaryAnimation.status != AnimationStatus.dismissed)
            SlideTransition(
              position: slideOutAnimation,
              child: FadeTransition(
                opacity: fadeOutAnimation,
                child: child,
              ),
            ),
          // New content sliding in with fade
          SlideTransition(
            position: slideInAnimation,
            child: FadeTransition(
              opacity: fadeInAnimation,
              child: child,
            ),
          ),
        ],
      );
    },
    transitionDuration: const Duration(milliseconds: 250),
    reverseTransitionDuration: const Duration(milliseconds: 250),
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
