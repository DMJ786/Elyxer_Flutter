/// App Router Configuration using go_router
/// Defines all navigation routes for the verification flow
library;

import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../screens/auth/landing_screen.dart';
import '../screens/auth/sign_in_screen.dart';
import '../screens/phone_input_screen.dart';
import '../screens/phone_otp_screen.dart';
import '../screens/username_screen.dart';
import '../screens/email_input_screen.dart';
import '../screens/email_otp_screen.dart';
import '../screens/complete_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/orientation/orientation_screen.dart';
import '../screens/onboarding/background_screen.dart';
import '../screens/photos_verification/photos_verification_screen.dart';
import '../screens/profile_studio/profile_studio_screen.dart';
import '../screens/chat/chats_screen.dart';
import '../screens/chat/conversation_screen.dart';
import '../models/chat_models.dart';
import '../screens/discovery/discover_screen.dart';
import '../screens/moments/moments_screen.dart';
import '../screens/moments/share_moment_screen.dart';
import '../models/moment_models.dart';
import '../screens/interests/interests_screen.dart';
import '../screens/interests/profile_preview_screen.dart';
import '../models/interest_models.dart';
import '../widgets/app_shell.dart';
import '../models/profile_studio_models.dart';
import '../screens/verification_flow_screen.dart';
import '../screens/debug/next_button_debug_screen.dart';

/// App router instance
final appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    // Route 0: Landing Screen (entry point)
    GoRoute(
      path: '/',
      name: 'landing',
      builder: (context, state) => const LandingScreen(),
    ),

    // Route 0b: Sign-In / Create Account
    GoRoute(
      path: '/signin',
      name: 'signin',
      builder: (context, state) => const SignInScreen(),
    ),

    // Route 1: Verification Flow (phone + email OTP steps)
    GoRoute(
      path: '/verification',
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

    // Route 3: Onboarding Flow (Module 1: Age, Gender, Pronoun)
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // Route 4: Orientation Flow (Module 2: Sexual Orientation, Dating Preference, Dating Goals)
    GoRoute(
      path: '/orientation',
      name: 'orientation',
      builder: (context, state) => const OrientationScreen(),
    ),

    // Route 5: Background - Education, Profession, Location
    GoRoute(
      path: '/background',
      name: 'background',
      builder: (context, state) => const BackgroundScreen(),
    ),

    // Route 5b: Photos & Selfie Verification (Module 5)
    GoRoute(
      path: '/photos-verification',
      name: 'photos-verification',
      builder: (context, state) => const PhotosVerificationScreen(),
    ),

    // Route 5c: Profile Studio (Module 6)
    GoRoute(
      path: '/profile-studio',
      name: 'profile-studio',
      builder: (context, state) => const ProfileStudioScreen(),
    ),

    // Main app shell — the five primary tabs in an indexed stack so each
    // keeps its own navigation stack + scroll/state across switches. Branch
    // order MUST match AppTab.values (profile, moments, discover, interests,
    // chat) so AppBottomNav's index lines up with the active branch.
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        // 0 · Profile — the user's own profile via Profile Studio (Module 6),
        // landing on the refined view with edit sheets (issue #66).
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile-home',
              name: 'profile-home',
              builder: (context, state) => const ProfileStudioScreen(
                initialStep: ProfileStudioStep.refined,
                asProfileTab: true,
              ),
            ),
          ],
        ),
        // 1 · Moments.
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/moments',
              name: 'moments',
              builder: (context, state) => const MomentsScreen(),
            ),
          ],
        ),
        // 2 · Discover — the landing tab after onboarding.
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/discover',
              name: 'discover',
              builder: (context, state) => const DiscoverScreen(),
            ),
          ],
        ),
        // 3 · Interests.
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/interests',
              name: 'interests',
              builder: (context, state) => const InterestsScreen(),
            ),
          ],
        ),
        // 4 · Chat.
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/chats',
              name: 'chats',
              builder: (context, state) => const ChatsScreen(),
            ),
          ],
        ),
      ],
    ),

    // Detail routes pushed over the shell (full-screen, no bottom nav).
    GoRoute(
      path: '/conversation',
      name: 'conversation',
      builder: (context, state) {
        final channel = state.extra as ChatChannel;
        return ConversationScreen(channel: channel);
      },
    ),
    GoRoute(
      path: '/share-moment',
      name: 'share-moment',
      builder: (context, state) =>
          ShareMomentScreen(editing: state.extra as Moment?),
    ),
    GoRoute(
      path: '/interest-vibe',
      name: 'interest-vibe',
      builder: (context, state) =>
          ProfilePreviewScreen.vibe(state.extra as ReceivedVibe),
    ),
    GoRoute(
      path: '/interest-invite',
      name: 'interest-invite',
      builder: (context, state) =>
          ProfilePreviewScreen.invite(state.extra as ReceivedInvite),
    ),

    // Route 6: Username Input
    GoRoute(
      path: '/username',
      name: 'username',
      builder: (context, state) => const UsernameScreen(),
    ),

    // Route 6: Email Input
    GoRoute(
      path: '/email-input',
      name: 'email-input',
      builder: (context, state) => const EmailInputScreen(),
    ),

    // Route 7: Email OTP Verification
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

    // Route 8: Completion Screen
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
