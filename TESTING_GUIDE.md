# Testing the Onboarding Animations

## Current Status

The onboarding flow is fully implemented and ready to test, but the existing verification files need to be updated to work without code generation.

## Quick Fix to Test Onboarding

### Step 1: Comment Out Problem Screens Temporarily

Edit `lib/routes/app_router.dart` and comment out the problematic routes:

```dart
final appRouter = GoRouter(
  initialLocation: '/onboarding',  // Start directly at onboarding
  debugLogDiagnostics: true,
  routes: [
    // Temporarily commented out - need to fix Freezed dependencies
    // GoRoute(
    //   path: '/',
    //   name: 'phone-input',
    //   builder: (context, state) => const PhoneInputScreen(),
    // ),

    // Route 3: Onboarding Flow (Age, Gender, Pronoun)
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // Comment out other routes temporarily
    // ...
  ],
);
```

### Step 2: Run the App

```bash
cd dating-app-verification-flutter
flutter run -d chrome
```

The app will launch directly to the onboarding flow!

## What to Test

### 1. **Age Input Screen**
- Enter birthdate in DD/MM/YYYY format
- Try invalid dates (day > 31, month > 12, year < 1900)
- Try age < 18 (should show error)
- Click Next arrow (bottom right) - should slide to gender screen

### 2. **Gender Selection Screen**
- Click on Man/Woman/Non-Binary buttons
- Watch radio button animate
- Toggle "Show on profile" checkbox
- Click Back arrow to return
- Click Next to proceed

### 3. **Pronoun Selection Screen**
- Click multiple pronoun chips (multi-select)
- Watch chips animate when selected (color/border changes)
- Toggle "Show on profile" checkbox
- Click Next to complete

### 4. **Watch the Animations**
- **Slide animation**: Screens slide horizontally (600ms)
- **Fade animation**: Opacity fades in/out (400ms)
- **Progress indicator**:
  - Icons grow from 40px to 60px when active
  - Icons turn into checkmarks when complete
  - Progress bars fill with gold gradient
  - All transitions: 300ms

### 5. **Navigation**
- Next button only activates when step is valid
- Back button appears after first step
- Error snackbar shows if validation fails

## Alternative: Fix Dependencies Properly

To run the full app with all screens:

1. **Re-enable code generation** in `pubspec.yaml`:
```yaml
dev_dependencies:
  build_runner: ^2.4.7
  freezed: ^2.4.6
  json_serializable: ^6.7.1
  riverpod_generator: ^2.3.9
```

2. **Upgrade all dependencies**:
```bash
flutter pub upgrade --major-versions
```

3. **Run code generation**:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Run the app**:
```bash
flutter run -d chrome
```

## Expected Behavior

✅ Smooth slide + fade transitions between screens
✅ Animated progress indicator showing current step
✅ Validation prevents advancing until step is complete
✅ Back navigation works correctly
✅ Gold gradient theme matches Figma design
✅ All animations are smooth (60 FPS)

## Troubleshooting

**Problem**: Compilation errors about Freezed
**Solution**: Follow "Alternative" steps above to properly enable code generation

**Problem**: Animations feel slow
**Solution**: Reduce duration values in `onboarding_screen.dart`:
- Line 41: PageView slide duration
- Line 44: Fade animation duration

**Problem**: Can't advance to next step
**Solution**: Check validation:
- Age: Must be valid date, 18+ years old
- Gender: Must select one option
- Pronoun: Must select at least one pronoun

---

Once you fix the dependencies or use the quick fix, you'll see the beautiful animations in action!
