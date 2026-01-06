# Onboarding Flow Implementation

## Overview
This document describes the implementation of the animated onboarding flow based on your Figma design. The implementation includes:

- **3 onboarding screens**: Age, Gender, and Pronoun selection
- **Slide + Fade animations** between screens
- **Animated progress indicator** showing current step
- **State management** using Riverpod
- **Responsive validation** for each step

## File Structure

### Models
- `lib/models/onboarding_models.dart` - Data models for onboarding flow
  - `OnboardingData` - Holds user selections
  - `Gender` enum - Gender options (Man, Woman, Non-Binary, Other)
  - `Pronouns` class - Predefined pronoun options
  - `OnboardingStep` enum - Steps in the flow

### Providers (State Management)
- `lib/providers/onboarding_provider.dart` - Riverpod state management
  - `currentOnboardingStepProvider` - Tracks current step
  - `onboardingDataNotifierProvider` - Manages user selections

### Screens
- `lib/screens/onboarding/onboarding_screen.dart` - Main container with animations
- `lib/screens/onboarding/age_input_screen.dart` - Age/birthdate entry (DD/MM/YYYY)
- `lib/screens/onboarding/gender_selection_screen.dart` - Gender selection with radio buttons
- `lib/screens/onboarding/pronoun_selection_screen.dart` - Multi-select pronoun chips

### Widgets
- `lib/widgets/onboarding_progress_indicator.dart` - Animated stepper showing progress

### Routing
- `lib/routes/app_router.dart` - Updated with onboarding route

## How It Works

### Animation System

**Slide + Fade Transition:**
```dart
// In onboarding_screen.dart
- PageView with custom slide animation (600ms, easeInOut curve)
- FadeTransition wrapper (400ms, easeInOut curve)
- Synchronized animations on page change
```

**Progress Indicator Animation:**
```dart
// In onboarding_progress_indicator.dart
- AnimatedContainer for icon size changes
- AnimatedSwitcher for icon transitions
- Gradient animations on active steps
- 300ms transitions by default
```

### Navigation Flow

1. **Age Entry** → Validates birthdate and minimum age (18+)
2. **Gender Selection** → Select gender identity with optional checkbox to show on profile
3. **Pronoun Selection** → Multi-select pronouns with optional checkbox
4. **Complete** → Submits data and navigates to email verification

### Usage

**To access the onboarding flow:**

```dart
// From any screen
context.push('/onboarding');

// Or set as initial route in app_router.dart
final appRouter = GoRouter(
  initialLocation: '/onboarding',  // Change from '/' to '/onboarding'
  // ... rest of config
);
```

**Navigation buttons:**
- **Next button** (bottom right) - Golden gradient circle with forward arrow
- **Back button** (bottom right, appears after first step) - Navigates to previous screen
- Validation prevents proceeding until step is complete

## Customization

### Colors & Theme
All design tokens match your Figma design in `lib/theme/app_theme.dart`:
- **Brand colors**: Gold gradient (#9B631C to #E3BD63)
- **Background**: Cream (#FFFFF6)
- **Interactive colors**: Grayscale from black to light gray
- **Fonts**: Playfair Display (headings), Inter (body text)

### Animation Timing
Modify animation durations in:
- `OnboardingScreen._nextPage()` - Slide duration (default: 600ms)
- `OnboardingScreen._fadeController` - Fade duration (default: 400ms)
- `OnboardingProgressIndicator.animationDuration` - Progress animations (default: 300ms)

### Validation Rules
Customize in `onboarding_provider.dart`:
```dart
bool _isAgeValid() {
  if (state.birthdate == null) return false;
  final age = DateTime.now().year - state.birthdate!.year;
  return age >= 18 && age <= 100; // Adjust minimum/maximum age
}
```

## Testing the Flow

1. **Start the app:**
   ```bash
   cd dating-app-verification-flutter
   flutter run
   ```

2. **Navigate to onboarding:**
   - If set as initial route, it will show on app launch
   - Or navigate programmatically: `context.push('/onboarding')`

3. **Test each step:**
   - **Age**: Enter birthdate (DD/MM/YYYY), validates minimum age 18
   - **Gender**: Select one of three options, optional profile display
   - **Pronoun**: Multi-select chips, at least one required
   - Click **Next** arrow to advance (validates before proceeding)
   - Click **Back** arrow to return to previous step

4. **Observe animations:**
   - Screens slide horizontally while fading
   - Progress indicator grows/shrinks active icon
   - Icons change to checkmark when complete
   - Progress bars fill with gold gradient

## Next Steps

### Data Submission
Currently, the onboarding data is stored in memory. To persist:

```dart
// In onboarding_provider.dart
Future<void> submit() async {
  // Replace TODO with actual API call:
  await api.submitOnboarding(
    birthdate: state.birthdate,
    gender: state.gender,
    pronouns: state.pronouns,
    // ... other fields
  );
}
```

### Email Integration
After onboarding completes, it navigates to `/email-input`. To change:

```dart
// In onboarding_screen.dart -> _submitOnboarding()
context.push('/email-input');  // Change to your desired route
```

### Adding Custom Pronoun Input
The "Other (self-describe)" chip is configured to show a custom input dialog:

```dart
// In pronoun_selection_screen.dart
_PronounChip(
  label: 'Other (self-describe)',
  onTap: () {
    // TODO: Show custom pronoun input dialog
    showDialog(...);
  },
),
```

## Dependencies Used

- `flutter_riverpod` - State management
- `hooks_riverpod` - React-like hooks for Flutter
- `go_router` - Declarative routing
- `google_fonts` - Playfair Display & Inter fonts
- `flutter_form_builder` & `form_builder_validators` - Form handling

## Architecture Notes

- **Stateless when possible**: Age, Gender, and Pronoun screens are `ConsumerWidget`
- **Stateful for animations**: Main `OnboardingScreen` uses `ConsumerStatefulWidget` for animation controllers
- **Immutable state**: All state changes create new copies (copyWith pattern)
- **Single source of truth**: Riverpod providers manage all state
- **Separation of concerns**: Models, providers, screens, and widgets in separate files

## Troubleshooting

**Issue: Animations feel slow**
- Reduce duration values in animation controllers

**Issue: Validation not working**
- Check `canProceed()` logic in `onboarding_provider.dart`

**Issue: Progress indicator not updating**
- Verify `currentOnboardingStepProvider` is being updated

**Issue: Navigation not working**
- Ensure `go_router` is properly configured in `main.dart`
- Check route paths match exactly

---

Created: 2026-01-03
Based on Figma: https://figma.com/design/AAXTnMuz1qffxkAf0R06G9/Onboarding-for-AI
