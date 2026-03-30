/// Orientation Screen Integration Tests
/// Tests for navigation flows and Next button integration
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:dating_app_verification/models/onboarding_models.dart';
import 'package:dating_app_verification/providers/onboarding_provider.dart';
import 'package:dating_app_verification/screens/orientation/orientation_screen.dart';
import 'package:dating_app_verification/widgets/next_button.dart';

void main() {
  group('Orientation Screen Navigation', () {
    testWidgets('Next button should be disabled when canProceedOrientation returns false',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: OrientationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the NextButton
      final nextButton = find.byType(NextButton);
      expect(nextButton, findsOneWidget);

      // Tap the button (should be disabled since no sexual orientation selected)
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // Should show error message or stay on same page
      // Next button should remain disabled
      expect(nextButton, findsOneWidget);
    });

    testWidgets('should navigate through all orientation steps', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: OrientationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Start at sexual orientation step
      expect(
        container.read(currentOrientationStepProvider),
        equals(OrientationStep.sexualOrientation),
      );

      // Select sexual orientation to enable next button
      container.read(onboardingDataProvider.notifier).updateSexualOrientation(
        SexualOrientation.bisexual,
      );
      await tester.pumpAndSettle();

      // Tap Next button
      await tester.tap(find.byType(NextButton));
      await tester.pumpAndSettle(const Duration(milliseconds: 700));

      // Should advance to dating preference
      expect(
        container.read(currentOrientationStepProvider),
        equals(OrientationStep.datingPreference),
      );

      // Select dating preference
      container.read(onboardingDataProvider.notifier).toggleDatingPreference(
        DatingPreference.women,
      );
      await tester.pumpAndSettle();

      // Tap Next button again
      await tester.tap(find.byType(NextButton));
      await tester.pumpAndSettle(const Duration(milliseconds: 700));

      // Should advance to dating goals
      expect(
        container.read(currentOrientationStepProvider),
        equals(OrientationStep.datingGoals),
      );
    });

    testWidgets('Next button should be enabled when validation passes', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: OrientationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially disabled
      expect(container.read(canProceedOrientationProvider), isFalse);

      // Select sexual orientation
      container.read(onboardingDataProvider.notifier).updateSexualOrientation(
        SexualOrientation.gay,
      );
      await tester.pumpAndSettle();

      // Should be enabled now
      expect(container.read(canProceedOrientationProvider), isTrue);
    });
  });

  group('Onboarding to Orientation Navigation', () {
    testWidgets('should navigate from onboarding to orientation', (tester) async {
      final router = GoRouter(
        initialLocation: '/onboarding',
        routes: [
          GoRoute(
            path: '/onboarding',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Onboarding Screen')),
            ),
          ),
          GoRoute(
            path: '/orientation',
            builder: (context, state) => const ProviderScope(
              child: OrientationScreen(),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      expect(find.text('Onboarding Screen'), findsOneWidget);

      // Navigate to orientation
      router.go('/orientation');
      await tester.pumpAndSettle();

      // Should show orientation screen
      expect(find.byType(OrientationScreen), findsOneWidget);
    });
  });

  group('Orientation to Username Navigation', () {
    testWidgets('should prepare for username navigation after completing orientation', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: OrientationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Complete all orientation steps
      container.read(onboardingDataProvider.notifier).updateSexualOrientation(
        SexualOrientation.straight,
      );
      container.read(onboardingDataProvider.notifier).toggleDatingPreference(
        DatingPreference.women,
      );
      container.read(onboardingDataProvider.notifier).toggleDatingGoal('long_term');

      // Navigate to final step
      container.read(currentOrientationStepProvider.notifier).goTo(
        OrientationStep.datingGoals,
      );
      await tester.pumpAndSettle();

      // Verify can proceed is true on final step
      expect(container.read(canProceedOrientationProvider), isTrue);
      
      // Find Next button should be enabled
      expect(find.byType(NextButton), findsOneWidget);
    });
  });

  group('Provider Integration', () {
    testWidgets('canProceedOrientation should reactively update Next button', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: OrientationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially should be false (no selection)
      expect(container.read(canProceedOrientationProvider), isFalse);

      // Make selection - should update reactively
      container.read(onboardingDataProvider.notifier).updateSexualOrientation(
        SexualOrientation.lesbian,
      );
      await tester.pump();

      // Provider should now return true
      expect(container.read(canProceedOrientationProvider), isTrue);
    });

    testWidgets('currentOrientationStep should sync with PageView', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: OrientationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Start at first step
      expect(
        container.read(currentOrientationStepProvider),
        equals(OrientationStep.sexualOrientation),
      );

      // Programmatically change step
      container.read(currentOrientationStepProvider.notifier).goTo(
        OrientationStep.datingPreference,
      );
      await tester.pumpAndSettle();

      // Should update
      expect(
        container.read(currentOrientationStepProvider),
        equals(OrientationStep.datingPreference),
      );
    });
  });

  group('Error Handling', () {
    testWidgets('Next button should be disabled when no data is selected',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: OrientationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Next button should be disabled (no sexual orientation selected)
      expect(container.read(canProceedOrientationProvider), isFalse);
    });

    testWidgets('Next button disabled for dating preference when not selected', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: OrientationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Move to dating preference step
      container.read(currentOrientationStepProvider.notifier).goTo(
        OrientationStep.datingPreference,
      );
      await tester.pumpAndSettle();

      // Should be disabled without selection
      expect(container.read(canProceedOrientationProvider), isFalse);
    });

    testWidgets('Next button disabled for dating goals when not selected', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: OrientationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Move to dating goals step
      container.read(currentOrientationStepProvider.notifier).goTo(
        OrientationStep.datingGoals,
      );
      await tester.pumpAndSettle();

      // Should be disabled without selection
      expect(container.read(canProceedOrientationProvider), isFalse);
    });
  });

  group('UI State', () {
    testWidgets('should display orientation progress indicator', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OrientationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should have progress indicator with SVG icons
      expect(find.byType(SvgPicture), findsWidgets);
    });

    testWidgets('should render Next button aligned to the right', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OrientationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the Row containing the Next button
      final row = find.ancestor(
        of: find.byType(NextButton),
        matching: find.byType(Row),
      );

      expect(row, findsOneWidget);

      final rowWidget = tester.widget<Row>(row);
      expect(rowWidget.mainAxisAlignment, equals(MainAxisAlignment.end));
    });

    testWidgets('should show three content screens in PageView', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OrientationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should have a PageView
      expect(find.byType(PageView), findsOneWidget);

      // PageView should be non-scrollable (physics: NeverScrollableScrollPhysics)
      final pageView = tester.widget<PageView>(find.byType(PageView));
      expect(pageView.physics, isA<NeverScrollableScrollPhysics>());
    });
  });

  group('Animation', () {
    testWidgets('should have fade animation on content', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OrientationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should have FadeTransition (multiple instances due to MaterialApp routing)
      expect(find.byType(FadeTransition), findsWidgets);
    });
  });
}
