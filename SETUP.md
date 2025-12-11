# Elyxer Flutter - Setup Instructions

Complete setup guide for the Elyxer dating app user verification flow.

---

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** >= 3.0.0 ([Install Flutter](https://flutter.dev/docs/get-started/install))
- **Dart SDK** >= 3.0.0 (comes with Flutter)
- **Git** ([Install Git](https://git-scm.com/downloads))
- **IDE**: VS Code or Android Studio with Flutter plugins

---

## 🚀 Quick Start (5 Steps)

### 1. Clone the Repository

```bash
git clone https://github.com/DMJ786/Elyxer_Flutter.git
cd Elyxer_Flutter
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Code (Freezed Models)

**IMPORTANT:** This step is required before running the app!

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates the following files:
- `*.freezed.dart` - Freezed model implementations
- `*.g.dart` - JSON serialization code

### 4. Verify Setup

```bash
flutter doctor
```

Ensure all checkmarks are green for your target platform (iOS/Android).

### 5. Run the App

```bash
# Run on connected device/emulator
flutter run

# Or specify platform
flutter run -d ios        # iOS
flutter run -d android    # Android
flutter run -d chrome     # Web (testing only)
```

---

## 🔧 Development Workflow

### Running in Development Mode

```bash
# Hot reload enabled by default
flutter run

# With verbose logging
flutter run -v
```

### Building for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS (requires Mac)
flutter build ios --release
```

### Code Generation (After Model Changes)

Whenever you modify files in `lib/models/`:

```bash
# Watch mode (auto-regenerate on changes)
flutter pub run build_runner watch --delete-conflicting-outputs

# One-time build
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 📁 Project Structure

```
Elyxer_Flutter/
├── lib/
│   ├── main.dart                       # App entry point
│   ├── routes/
│   │   └── app_router.dart            # Navigation configuration
│   ├── screens/                        # 5 verification screens
│   │   ├── phone_input_screen.dart    # Layer 1: Phone input
│   │   ├── phone_otp_screen.dart      # Layer 2: Phone OTP
│   │   ├── username_screen.dart       # Layer 3: Username
│   │   ├── email_input_screen.dart    # Layer 4: Email input
│   │   ├── email_otp_screen.dart      # Layer 5: Email OTP
│   │   └── complete_screen.dart       # Success screen
│   ├── widgets/                        # Reusable UI components
│   │   ├── otp_input.dart
│   │   ├── custom_button.dart
│   │   ├── info_banner.dart
│   │   └── progress_indicator.dart
│   ├── models/                         # Data models (Freezed)
│   │   └── verification_models.dart
│   ├── providers/                      # State management (Riverpod)
│   │   └── verification_provider.dart
│   ├── services/                       # API services
│   │   └── verification_service.dart
│   └── theme/                          # Material 3 theme
│       └── app_theme.dart
├── pubspec.yaml                        # Dependencies
├── .gitignore                          # Git ignore rules
├── README.md                           # Project overview
└── SETUP.md                            # This file
```

---

## 🔌 Backend Integration

The app currently uses placeholder API calls. To integrate your backend:

1. Open `lib/services/verification_service.dart`
2. Replace `API_BASE_URL` with your backend URL:

```dart
const API_BASE_URL = 'https://your-api.elyxer.com/api';
```

3. Implement the following endpoints:

| Method | Endpoint | Request Body | Response |
|--------|----------|--------------|----------|
| POST | `/auth/send-phone-otp` | `{countryCode, phoneNumber}` | `{success, expiresAt}` |
| POST | `/auth/verify-phone-otp` | `{code}` | `{success, token}` |
| POST | `/auth/username` | `{firstName, lastName}` | `{success}` |
| POST | `/auth/send-email-otp` | `{email}` | `{success, expiresAt}` |
| POST | `/auth/verify-email-otp` | `{code}` | `{success, token}` |
| POST | `/auth/email-preferences` | `{email, enableNotifications}` | `{success}` |

---

## 🎨 Customization

### Change Brand Colors

Edit `lib/theme/app_theme.dart`:

```dart
class AppColors {
  static const brandDark = Color(0xFF9B631C);   // Change to your brand
  static const brandLight = Color(0xFFE3BD63);  // Lighter variant
}
```

### Update App Name

Edit `pubspec.yaml`:

```yaml
name: elyxer_flutter  # Change package name
description: Your description
```

### Change App Icon

1. Replace `assets/icon/app_icon.png`
2. Run:
```bash
flutter pub run flutter_launcher_icons
```

---

## 🐛 Troubleshooting

### Problem: "flutter: command not found"

**Solution:**
```bash
# Verify Flutter installation
which flutter

# Add Flutter to PATH (Mac/Linux)
export PATH="$PATH:/path/to/flutter/bin"

# Add Flutter to PATH (Windows)
# Add C:\path\to\flutter\bin to System Environment Variables
```

### Problem: Build runner fails

**Solution:**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Problem: "Waiting for another flutter command to release the startup lock"

**Solution:**
```bash
# Kill Flutter processes
killall -9 dart

# Or delete lock file
rm -rf /path/to/flutter/bin/cache/lockfile
```

### Problem: Android build fails

**Solution:**
```bash
# Clean Android build
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Problem: iOS build fails

**Solution:**
```bash
# Clean iOS build
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter clean
flutter pub get
flutter run
```

---

## 🧪 Testing

### Run Tests

```bash
# All tests
flutter test

# Specific test file
flutter test test/models/verification_models_test.dart

# With coverage
flutter test --coverage
```

### Integration Tests

```bash
flutter drive --target=test_driver/app.dart
```

---

## 📱 Platform-Specific Setup

### iOS Setup

1. Install Xcode from Mac App Store
2. Install CocoaPods:
```bash
sudo gem install cocoapods
```
3. Configure code signing in Xcode:
```bash
open ios/Runner.xcworkspace
```

### Android Setup

1. Install Android Studio
2. Install Android SDK (API level 21+)
3. Accept licenses:
```bash
flutter doctor --android-licenses
```

---

## 🔐 Environment Variables

For sensitive data (API keys, etc.), create a `.env` file:

```bash
# .env (add to .gitignore!)
API_BASE_URL=https://api.elyxer.com
API_KEY=your_api_key_here
```

Then load using `flutter_dotenv` package.

---

## 📚 Resources

- **Flutter Docs**: https://flutter.dev/docs
- **Riverpod Docs**: https://riverpod.dev
- **Freezed Docs**: https://pub.dev/packages/freezed
- **go_router Docs**: https://pub.dev/packages/go_router
- **Material 3 Design**: https://m3.material.io

---

## 🤝 Contributing

1. Create a feature branch: `git checkout -b feature/your-feature`
2. Make your changes
3. Run tests: `flutter test`
4. Commit: `git commit -m "Add your feature"`
5. Push: `git push origin feature/your-feature`
6. Create Pull Request

---

## 📄 License

[Add your license here]

---

## 📞 Support

For issues or questions:
- **Email**: support@elyxer.com
- **GitHub Issues**: https://github.com/DMJ786/Elyxer_Flutter/issues
- **Figma Design**: [Onboarding Module](https://www.figma.com/design/AAXTnMuz1qffxkAf0R06G9)

---

**Built with ❤️ using Flutter + Riverpod + Freezed + Material 3**
