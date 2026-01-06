# Remaining Fixes - TODO

**Created**: December 20, 2025
**Status**: Ready for Implementation
**Estimated Time**: 30-40 minutes

---

## 📋 Overview

4 screen files need fixes to be fully compatible with upgraded packages. All fixes follow established patterns from the 2 screens already completed.

**Completed Screens**: phone_input_screen.dart ✅, username_screen.dart ✅
**Remaining Screens**: complete_screen.dart, email_input_screen.dart, email_otp_screen.dart, phone_otp_screen.dart

---

## 🔧 Screen 1: complete_screen.dart

**Location**: `lib/screens/complete_screen.dart`

### Issues to Fix:

#### Issue 1: CustomProgressIndicator → ProgressIndicatorWidget
**Line**: ~26

```dart
// CURRENT (BROKEN):
const CustomProgressIndicator(currentStep: 3),

// FIX TO:
ProgressIndicatorWidget(
  currentStep: 3,
  steps: const [
    ProgressStep(id: '1', icon: StepIcon.phone, status: StepStatus.completed),
    ProgressStep(id: '2', icon: StepIcon.account, status: StepStatus.completed),
    ProgressStep(id: '3', icon: StepIcon.mail, status: StepStatus.completed),
    ProgressStep(id: '4', icon: StepIcon.complete, status: StepStatus.completed),
  ],
),
```

#### Issue 2: Button label parameter
**Line**: ~66

```dart
// CURRENT (BROKEN):
CustomButton(
  label: 'Get Started',
  onPressed: onComplete,
)

// FIX TO:
CustomButton(
  title: 'Get Started',
  onPressed: onComplete,
)
```

#### Issue 3: Add model import
**Top of file**

```dart
// ADD THIS IMPORT:
import '../models/verification_models.dart';
```

---

## 🔧 Screen 2: email_input_screen.dart

**Location**: `lib/screens/email_input_screen.dart`

### Issues to Fix:

#### Issue 1: Provider references
**Lines**: ~38, ~44

```dart
// CURRENT (BROKEN):
await ref.read(verificationProvider.notifier).submitEmailPreferences(...)

// FIX TO:
final emailData = EmailInputData(
  email: email,
  enableNotifications: enableNotifications,
);

// Store email data
ref.read(emailInputProvider.notifier).state = emailData;

// Submit email preferences
ref.read(submitEmailPreferencesProvider(emailData).future).then((_) {
  // Handle success
}).catchError((e) {
  // Handle error
});
```

#### Issue 2: CustomProgressIndicator → ProgressIndicatorWidget
**Line**: ~85

```dart
// CURRENT (BROKEN):
const CustomProgressIndicator(currentStep: 2),

// FIX TO:
ProgressIndicatorWidget(
  currentStep: 2,
  steps: const [
    ProgressStep(id: '1', icon: StepIcon.phone, status: StepStatus.completed),
    ProgressStep(id: '2', icon: StepIcon.account, status: StepStatus.completed),
    ProgressStep(id: '3', icon: StepIcon.mail, status: StepStatus.inProgress),
    ProgressStep(id: '4', icon: StepIcon.complete, status: StepStatus.incomplete),
  ],
),
```

#### Issue 3: Button label parameters
**Lines**: ~134, ~143

```dart
// CURRENT (BROKEN):
CustomButton(
  label: 'Continue',
  onPressed: _isLoading ? null : _handleContinue,
)

// FIX TO:
CustomButton(
  title: 'Continue',
  onPressed: _handleContinue,
  isLoading: _isLoading,
  isDisabled: _isLoading,
)
```

```dart
// CURRENT (BROKEN):
CustomButton(
  label: 'Skip for now',
  ...
)

// FIX TO:
CustomButton(
  title: 'Skip for now',
  ...
)
```

#### Issue 4: Async callback fix
**Line**: ~27

```dart
// CURRENT (BROKEN):
Future<void> _handleContinue() async {
  ...
}

// FIX TO:
void _handleContinue() {
  // Change implementation to use .then() pattern as shown in Issue 1
}
```

#### Issue 5: Add model import
**Top of file**

```dart
// ADD THIS IMPORT:
import '../models/verification_models.dart';
```

---

## 🔧 Screen 3: email_otp_screen.dart

**Location**: `lib/screens/email_otp_screen.dart`

### Issues to Fix:

#### Issue 1: Provider references
**Lines**: ~62, ~84

```dart
// CURRENT (BROKEN):
await ref.read(verificationProvider.notifier).verifyEmailOTP(...)

// FIX TO:
final email = ref.read(emailInputProvider)?.email ?? '';
ref.read(verifyEmailOTPProvider(email, _code).future).then((_) {
  // Handle success
}).catchError((e) {
  // Handle error
});
```

#### Issue 2: CustomProgressIndicator → ProgressIndicatorWidget
**Line**: ~113

```dart
// CURRENT (BROKEN):
const CustomProgressIndicator(currentStep: 3),

// FIX TO:
ProgressIndicatorWidget(
  currentStep: 3,
  steps: const [
    ProgressStep(id: '1', icon: StepIcon.phone, status: StepStatus.completed),
    ProgressStep(id: '2', icon: StepIcon.account, status: StepStatus.completed),
    ProgressStep(id: '3', icon: StepIcon.mail, status: StepStatus.completed),
    ProgressStep(id: '4', icon: StepIcon.complete, status: StepStatus.inProgress),
  ],
),
```

#### Issue 3: OTPInput widget API
**Line**: ~131-133

```dart
// CURRENT (BROKEN):
OTPInput(
  length: 6,
  onCompleted: (code) {
    setState(() => _code = code);
    _handleVerify();
  },
)

// FIX TO:
OTPInput(
  value: _code,
  onChanged: (code) {
    setState(() => _code = code);
    if (code.length == 6) {
      _handleVerify();
    }
  },
)
```

#### Issue 4: Add state variable for OTP code
**In _EmailOTPScreenState class**

```dart
// ADD THIS:
String _code = '';
```

#### Issue 5: Add model import
**Top of file**

```dart
// ADD THIS IMPORT:
import '../models/verification_models.dart';
```

---

## 🔧 Screen 4: phone_otp_screen.dart

**Location**: `lib/screens/phone_otp_screen.dart`

### Issues to Fix:

#### Issue 1: Provider references
**Lines**: ~64, ~86

```dart
// CURRENT (BROKEN):
await ref.read(verificationProvider.notifier).verifyPhoneOTP(...)

// FIX TO:
final phoneData = ref.read(phoneInputProvider);
if (phoneData != null) {
  ref.read(verifyPhoneOTPProvider(phoneData, _code).future).then((_) {
    // Handle success - navigate to username screen
    if (mounted) {
      context.push('/username');
    }
  }).catchError((e) {
    // Handle error
  });
}
```

#### Issue 2: CustomProgressIndicator → ProgressIndicatorWidget
**Line**: ~118

```dart
// CURRENT (BROKEN):
const CustomProgressIndicator(currentStep: 1),

// FIX TO:
ProgressIndicatorWidget(
  currentStep: 1,
  steps: const [
    ProgressStep(id: '1', icon: StepIcon.phone, status: StepStatus.completed),
    ProgressStep(id: '2', icon: StepIcon.account, status: StepStatus.inProgress),
    ProgressStep(id: '3', icon: StepIcon.mail, status: StepStatus.incomplete),
    ProgressStep(id: '4', icon: StepIcon.complete, status: StepStatus.incomplete),
  ],
),
```

#### Issue 3: OTPInput widget API
**Line**: ~136-138

```dart
// CURRENT (BROKEN):
OTPInput(
  length: 6,
  onCompleted: (code) {
    setState(() => _code = code);
    _handleVerify();
  },
)

// FIX TO:
OTPInput(
  value: _code,
  onChanged: (code) {
    setState(() => _code = code);
    if (code.length == 6) {
      _handleVerify();
    }
  },
)
```

#### Issue 4: Add state variable for OTP code
**In _PhoneOTPScreenState class**

```dart
// ADD THIS:
String _code = '';
```

#### Issue 5: Add model import
**Top of file**

```dart
// ADD THIS IMPORT:
import '../models/verification_models.dart';
```

---

## 📝 Additional Notes

### StateProvider Import Issue

If you see errors about `StateProvider` being undefined, add this explicit import to `verification_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart' show StateProvider;
```

Or make the import more explicit:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
```

### Freezed Model Warnings

The analyzer errors about "Missing concrete implementations" for Freezed models are false positives. The code generation completed successfully, and these errors should not prevent compilation. They may disappear after:

1. Restarting your IDE
2. Running `flutter clean && flutter pub get`
3. Rebuilding the project

---

## 🎯 Implementation Order (Recommended)

1. **complete_screen.dart** (Easiest - 2 simple fixes)
2. **email_input_screen.dart** (Medium - provider + button fixes)
3. **phone_otp_screen.dart** (Medium - OTP widget + provider)
4. **email_otp_screen.dart** (Medium - same as phone_otp)

---

## ✅ Verification Steps

After completing each screen:

```bash
# Run analyzer to check for errors
flutter analyze lib/screens/[screen_name].dart

# After all fixes, run full analysis
flutter analyze

# Test build
flutter build apk --debug
```

---

## 📚 Reference Files

For examples of correct implementation, refer to:
- **phone_input_screen.dart** - Complete working example
- **username_screen.dart** - Complete working example
- **FIXES_COMPLETED.md** - All fix patterns documented

---

**Estimated Time per Screen**:
- complete_screen.dart: 5 minutes
- email_input_screen.dart: 10 minutes
- phone_otp_screen.dart: 10 minutes
- email_otp_screen.dart: 10 minutes

**Total**: ~35 minutes

---

## 🆘 Common Gotchas

1. **Don't forget** to add `import '../models/verification_models.dart';` at the top
2. **Remember** to create state variables for OTP codes (`String _code = '';`)
3. **Check** that step statuses in ProgressIndicatorWidget match the screen position
4. **Verify** button callbacks are sync (`void`) not async (`Future<void>`)

---

**Document Version**: 1.0
**Last Updated**: December 20, 2025
