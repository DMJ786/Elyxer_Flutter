# Dating App - User Verification Flow (Flutter)

**Flutter implementation of the 5-layer user verification module**

Generated from Figma Design: [Onboarding for AI](https://www.figma.com/design/AAXTnMuz1qffxkAf0R06G9/Onboarding-for-AI?node-id=111-5966&m=dev)

---

## 📋 Overview

Complete Flutter implementation of a dating app's user verification flow with 5 screens:

1. **Phone Input Screen** (Layer 1) - User enters phone number with country code picker
2. **Phone OTP Verification** (Layer 2) - 6-digit OTP with 2-minute timer
3. **Username Input** (Layer 3) - First name (required) + Last name (optional)
4. **Email Input** (Layer 4) - Email with notification preferences + skip option
5. **Email OTP Verification** (Layer 5) - 6-digit OTP with 2-minute timer

---

## ✨ Features

### Design System
- ✅ **Material 3 Theme** - Modern Material Design with custom ColorScheme
- ✅ **Design Tokens** - Complete token system (colors, spacing, typography, radius)
- ✅ **Custom Theme** - Gold gradient (#9B631C → #E3BD63) + cream background (#FFFFF6)
- ✅ **Google Fonts** - Playfair Display (headings) + Inter (body text)
- ✅ **Semantic Colors** - Proper error/success/warning/info/focus states

### State Management
- ✅ **Riverpod** - Modern, flexible state management
- ✅ **Freezed Models** - Immutable data classes with code generation
- ✅ **JSON Serializable** - Type-safe JSON serialization

### Navigation
- ✅ **go_router** - Declarative routing with type-safe navigation
- ✅ **Deep Linking** - Ready for deep link integration

### Components
- ✅ **OTPInput** - 6-digit input with auto-focus and paste support
- ✅ **CustomButton** - 3 variants (primary gradient, secondary, text)
- ✅ **InfoBanner** - Informational messages with icons
- ✅ **ProgressIndicator** - 4-step progress visualization

### Validation
- ✅ **Phone** - 10-digit validation with country code
- ✅ **OTP** - 6-digit numeric input with timer
- ✅ **Username** - Min 2 chars, pattern validation
- ✅ **Email** - Standard email validation

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0

### Installation

```bash
# Navigate to project directory
cd dating-app-verification-flutter

# Install dependencies
flutter pub get

# Generate freezed model files
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Running on Different Platforms

```bash
# Run on iOS
flutter run -d ios

# Run on Android
flutter run -d android

# Run on Web (for testing)
flutter run -d chrome
```

---

## 📁 Project Structure

```
dating-app-verification-flutter/
├── lib/
│   ├── main.dart                       # App entry point
│   ├── routes/
│   │   └── app_router.dart            # go_router configuration
│   ├── screens/
│   │   ├── phone_input_screen.dart    # Layer 1
│   │   ├── phone_otp_screen.dart      # Layer 2
│   │   ├── username_screen.dart       # Layer 3
│   │   ├── email_input_screen.dart    # Layer 4
│   │   ├── email_otp_screen.dart      # Layer 5
│   │   └── complete_screen.dart       # Completion
│   ├── widgets/
│   │   ├── otp_input.dart
│   │   ├── custom_button.dart
│   │   ├── info_banner.dart
│   │   └── progress_indicator.dart
│   ├── models/
│   │   └── verification_models.dart   # Freezed models
│   ├── providers/
│   │   └── verification_provider.dart # Riverpod providers
│   ├── services/
│   │   └── verification_service.dart  # API service
│   └── theme/
│       └── app_theme.dart             # Material 3 theme
├── pubspec.yaml                        # Dependencies
└── README.md                           # This file
```

---

## 🎨 Design System

### Color Tokens

```dart
// Base
cream: #FFFFF6  // Background

// Brand (Gold gradient)
brandDark: #9B631C
brandLight: #E3BD63

// Interactive (grays/blacks)
interactive500: #000000  // Primary text
interactive400: #333333  // Secondary text
interactive300: #666666  // Tertiary text
interactive200: #B3B3B3  // Placeholders
interactive100: #E0E0E0  // Borders

// Semantic
error: #EF4444    // Red for errors
success: #10B981  // Green for success
warning: #F59E0B  // Amber for warnings
info: #3B82F6     // Blue for info
focus: #3B82F6    // Blue for focus states
```

### Typography

```dart
// Font Families
heading: Playfair Display Bold
body: Inter Regular/SemiBold/Medium

// Text Styles
displayLarge: 28px (line-height: 32px)  // Headings
bodyLarge: 16px (line-height: 24px)     // Paragraph large
bodyMedium: 14px (line-height: 20px)    // Paragraph medium
bodySmall: 12px (line-height: 18px)     // Paragraph small
labelLarge: 16px (weight: 600)          // Button text
```

### Spacing (4px grid)

```dart
x1: 4px   x2: 8px   x3: 12px  x4: 16px
x5: 20px  x6: 24px  x8: 32px  x14: 56px
```

### Border Radius

```dart
small: 4px   medium: 8px   large: 16px   round: 999px
```

---

## 🔌 API Integration

All API calls are placeholders in `lib/services/verification_service.dart`. Replace with your backend endpoints:

```dart
const API_BASE_URL = 'https://your-api-endpoint.com/api';

// Endpoints to implement:
- POST /auth/send-phone-otp
- POST /auth/verify-phone-otp
- POST /auth/username
- POST /auth/send-email-otp
- POST /auth/verify-email-otp
- POST /auth/email-preferences
```

---

## 🔧 Customization

### Change Brand Colors

Edit `lib/theme/app_theme.dart`:

```dart
class AppColors {
  static const brandDark = Color(0xFF9B631C);  // Your brand color
  static const brandLight = Color(0xFFE3BD63); // Lighter variant
}
```

### Modify Validation Rules

Edit validation rules in screen components:

```dart
// Example: Phone validation in phone_input_screen.dart
FormBuilderValidators.match(
  r'^[0-9]{10}$',  // Change pattern here
  errorText: 'Custom error message',
)
```

---

## 🎯 Next Steps

### High Priority
1. **Implement Backend APIs** - Replace placeholder API calls in `verification_service.dart`
2. **Country Code Picker** - Implement full country picker modal (currently shows 3 countries)
3. **Error Handling** - Add comprehensive error handling and user feedback
4. **Testing** - Add unit tests for providers and integration tests

### Medium Priority
5. **Accessibility** - Add semantic labels and screen reader support
6. **Loading States** - Improve loading UX with skeleton screens
7. **Biometric Auth** - Add Face ID/Touch ID support (optional)
8. **Deep Linking** - Handle OTP deep links from SMS/email
9. **Analytics** - Add event tracking for funnel analysis

### Low Priority
10. **Animations** - Add micro-interactions and transitions
11. **Dark Mode** - Implement dark theme support
12. **Localization** - Add i18n support for multiple languages

---

## 🐛 Troubleshooting

### Build Runner Issues

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Hot Reload Issues

```bash
# Restart the app
flutter run --hot
```

### Dependency Conflicts

```bash
# Update dependencies
flutter pub upgrade

# Check for outdated packages
flutter pub outdated
```

---

## 📦 Dependencies

### Core Dependencies
- `flutter` - Flutter SDK
- `hooks_riverpod: ^2.4.9` - State management
- `riverpod_annotation: ^2.3.3` - Riverpod code generation
- `go_router: ^12.1.3` - Declarative routing
- `flutter_form_builder: ^9.1.1` - Form management
- `form_builder_validators: ^9.1.0` - Form validation
- `freezed_annotation: ^2.4.1` - Immutable models
- `json_annotation: ^4.8.1` - JSON serialization
- `google_fonts: ^6.1.0` - Custom fonts
- `flutter_hooks: ^0.20.4` - React-style hooks
- `dio: ^5.4.0` - HTTP client (for API calls)

### Dev Dependencies
- `build_runner: ^2.4.7` - Code generation
- `freezed: ^2.4.6` - Freezed code generator
- `json_serializable: ^6.7.1` - JSON code generator
- `riverpod_generator: ^2.3.9` - Riverpod code generator
- `flutter_lints: ^3.0.1` - Linting rules

---

## 📄 Tech Stack Summary

| Category | Technology |
|----------|------------|
| **Framework** | Flutter 3.0+ |
| **Language** | Dart 3.0+ |
| **State Management** | Riverpod (NOT Bloc/Cubit) |
| **Models** | freezed + json_serializable |
| **Routing** | go_router |
| **Forms** | flutter_form_builder |
| **UI** | Material 3 + Custom Theme |
| **Fonts** | Google Fonts (Playfair Display + Inter) |
| **HTTP** | dio |
| **Hooks** | flutter_hooks |

---

## 📞 Support

For issues or questions about the implementation:
- Check Figma design: [Onboarding Module](https://www.figma.com/design/AAXTnMuz1qffxkAf0R06G9)
- Review Flutter docs: https://flutter.dev/docs
- Riverpod docs: https://riverpod.dev

---

**Generated with ❤️ from Figma Design → Flutter Code**

**Design System:** Material 3 + Custom Gold Gradient Theme + Riverpod + freezed
