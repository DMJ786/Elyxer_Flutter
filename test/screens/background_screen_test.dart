/// Background Screen Tests
/// Tests for BackgroundScreen widget (Education, Profession, Location flow)
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dating_app_verification/models/onboarding_models.dart';
import 'package:dating_app_verification/providers/onboarding_provider.dart';
import 'package:dating_app_verification/screens/onboarding/background_screen.dart';
import 'package:dating_app_verification/widgets/background_progress_indicator.dart';
import 'package:dating_app_verification/widgets/next_button.dart';

/// Set a large viewport to prevent overflow in the EducationEntryScreen Column.
void _setUpViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  group('BackgroundScreen structure', () {
    testWidgets('should render BackgroundProgressIndicator', (tester) async {
      _setUpViewport(tester);
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: BackgroundScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(BackgroundProgressIndicator), findsOneWidget);
    });

    testWidgets('should render PageView with sub-screens', (tester) async {
      _setUpViewport(tester);
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: BackgroundScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PageView), findsOneWidget);

      // PageView should not be scrollable manually
      final pageView = tester.widget<PageView>(find.byType(PageView));
      expect(pageView.physics, isA<NeverScrollableScrollPhysics>());
    });

    testWidgets('should have FadeTransition for content animation',
        (tester) async {
      _setUpViewport(tester);
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: BackgroundScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FadeTransition), findsWidgets);
    });

    testWidgets('should show NextButton widget', (tester) async {
      _setUpViewport(tester);
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: BackgroundScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NextButton), findsOneWidget);
    });

    testWidgets('should show "Skip for now" link on education step',
        (tester) async {
      _setUpViewport(tester);
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: BackgroundScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Skip for now'), findsOneWidget);
    });

    testWidgets('should not show back button on any step', (tester) async {
      _setUpViewport(tester);
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: BackgroundScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // No back button in background module
      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });

    testWidgets('should show education screen on initial load', (tester) async {
      _setUpViewport(tester);
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: BackgroundScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Education entry screen should have "Your Education" title
      expect(find.text('Your Education'), findsOneWidget);
    });
  });

  group('BackgroundScreen navigation', () {
    testWidgets('tapping next should advance to profession step',
        (tester) async {
      _setUpViewport(tester);
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set up education data so validation passes
      container.read(onboardingDataProvider.notifier)
          .updateEducationLevel(EducationLevel.undergraduate);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: BackgroundScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Start at education
      expect(
        container.read(currentBackgroundStepProvider),
        equals(BackgroundStep.education),
      );

      // Tap the NextButton
      await tester.tap(find.byType(NextButton));
      await tester.pumpAndSettle(const Duration(milliseconds: 700));

      // Should advance to profession
      expect(
        container.read(currentBackgroundStepProvider),
        equals(BackgroundStep.profession),
      );
    });

    testWidgets('skip for now should advance to next step', (tester) async {
      _setUpViewport(tester);
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: BackgroundScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Start at education
      expect(
        container.read(currentBackgroundStepProvider),
        equals(BackgroundStep.education),
      );

      // Tap "Skip for now"
      await tester.tap(find.text('Skip for now'));
      await tester.pumpAndSettle(const Duration(milliseconds: 700));

      // Should advance to profession
      expect(
        container.read(currentBackgroundStepProvider),
        equals(BackgroundStep.profession),
      );
    });

    testWidgets('should hide skip link on location step', (tester) async {
      _setUpViewport(tester);
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: BackgroundScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Advance to location
      container.read(currentBackgroundStepProvider.notifier).goTo(
        BackgroundStep.location,
      );
      await tester.pumpAndSettle();

      // Skip link should be hidden on location step
      expect(find.text('Skip for now'), findsNothing);
    });

    testWidgets('should navigate through all steps in order', (tester) async {
      _setUpViewport(tester);
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set up data for all steps so validation passes
      final notifier = container.read(onboardingDataProvider.notifier);
      notifier.updateEducationLevel(EducationLevel.undergraduate);
      notifier.updateIndustry('Technology');
      notifier.updateLocationQuery('New York, NY');

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: BackgroundScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Step 1: Education
      expect(
        container.read(currentBackgroundStepProvider),
        equals(BackgroundStep.education),
      );

      // Advance to Step 2: Profession
      await tester.tap(find.byType(NextButton));
      await tester.pumpAndSettle(const Duration(milliseconds: 700));
      expect(
        container.read(currentBackgroundStepProvider),
        equals(BackgroundStep.profession),
      );

      // Advance to Step 3: Location
      await tester.tap(find.byType(NextButton));
      await tester.pumpAndSettle(const Duration(milliseconds: 700));
      expect(
        container.read(currentBackgroundStepProvider),
        equals(BackgroundStep.location),
      );

      // Advance to Step 4: Complete
      await tester.tap(find.byType(NextButton));
      await tester.pumpAndSettle(const Duration(milliseconds: 700));
      expect(
        container.read(currentBackgroundStepProvider),
        equals(BackgroundStep.complete),
      );
    });
  });

  group('BackgroundScreen complete state', () {
    testWidgets('should stay on current page when complete',
        (tester) async {
      _setUpViewport(tester);
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: BackgroundScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Go to complete step
      container.read(currentBackgroundStepProvider.notifier).goTo(
        BackgroundStep.complete,
      );
      await tester.pumpAndSettle();

      // Should still show page content (not a separate complete screen)
      expect(find.byType(PageView), findsOneWidget);

      // Should NOT show "All Set!" text
      expect(find.text('All Set!'), findsNothing);
    });

    testWidgets('should hide skip link on complete step',
        (tester) async {
      _setUpViewport(tester);
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: BackgroundScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Go to complete step
      container.read(currentBackgroundStepProvider.notifier).goTo(
        BackgroundStep.complete,
      );
      await tester.pumpAndSettle();

      // Skip should be hidden
      expect(find.text('Skip for now'), findsNothing);
      // No back button at all
      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });
  });

  group('BackgroundScreen routing', () {
    testWidgets('should navigate from orientation to background',
        (tester) async {
      _setUpViewport(tester);
      final router = GoRouter(
        initialLocation: '/orientation',
        routes: [
          GoRoute(
            path: '/orientation',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Orientation Screen')),
            ),
          ),
          GoRoute(
            path: '/background',
            builder: (context, state) => const ProviderScope(
              child: BackgroundScreen(),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      expect(find.text('Orientation Screen'), findsOneWidget);

      // Navigate to background
      router.go('/background');
      await tester.pumpAndSettle();

      // Should show background screen
      expect(find.byType(BackgroundScreen), findsOneWidget);
    });
  });

  group('BackgroundScreen provider integration', () {
    testWidgets('progress indicator should reflect current step',
        (tester) async {
      _setUpViewport(tester);
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: BackgroundScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Start at education
      final indicator = tester.widget<BackgroundProgressIndicator>(
        find.byType(BackgroundProgressIndicator),
      );
      expect(indicator.currentStep, equals(BackgroundStep.education));

      // Advance to profession
      container.read(currentBackgroundStepProvider.notifier).next();
      await tester.pumpAndSettle();

      final updatedIndicator = tester.widget<BackgroundProgressIndicator>(
        find.byType(BackgroundProgressIndicator),
      );
      expect(updatedIndicator.currentStep, equals(BackgroundStep.profession));
    });
  });
}
