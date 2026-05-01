# Elyxer Flutter - Dating App Verification & Onboarding

## Project Overview
Flutter dating app with a multi-module user verification and onboarding flow, built from Figma designs using Material 3.

## Tech Stack
- **Framework**: Flutter 3.8+ / Dart 3.8+
- **State Management**: Riverpod 3.0 (`flutter_riverpod`, `riverpod_annotation`, `hooks_riverpod`)
- **Navigation**: GoRouter 17.0
- **Models**: Freezed 3.2 + json_serializable (immutable, code-generated)
- **Forms**: flutter_form_builder + form_builder_validators
- **UI**: flutter_svg, google_fonts (Playfair Display + Inter), flutter_hooks
- **Build**: build_runner for code generation

## Architecture

### Pattern: Riverpod + Freezed + GoRouter
```
lib/
├── main.dart                    # ProviderScope + MaterialApp.router
├── routes/app_router.dart       # GoRouter with all routes
├── screens/                     # Screen widgets (one per route)
│   ├── onboarding/              # Module 1: Age, Gender, Pronoun
│   ├── orientation/             # Module 2: Sexual Orientation, Dating Pref, Goals
│   └── onboarding/module4_screen.dart  # Module 4: Education, Profession, Location
├── widgets/                     # Reusable UI components
├── models/                      # Freezed data models + enums
├── providers/                   # Riverpod providers + notifiers
├── services/                    # API service layer (currently mock)
└── theme/app_theme.dart         # Design tokens: AppColors, AppSpacing, AppRadius, AppTheme
```

### Module Flow
1. **Verification** (5 screens): Phone Input → Phone OTP → Username → Email Input → Email OTP → Complete
2. **Onboarding Module 1** (3 screens): Age → Gender → Pronoun
3. **Orientation Module 2** (3 screens): Sexual Orientation → Dating Preference → Dating Goals
4. **Module 4** (3 screens): Education → Profession → Location

### Key Routes (GoRouter)
- `/` → VerificationFlowScreen (entry with animations)
- `/phone-otp` → PhoneOTPScreen (receives phoneNumber + countryCode via extra)
- `/onboarding` → OnboardingScreen (Module 1 container)
- `/orientation` → OrientationScreen (Module 2 container)
- `/module4` → Module4Screen (Module 4 container)
- `/username`, `/email-input`, `/email-otp`, `/complete`

## Conventions

### State Management Rules
- Use `@riverpod` annotation for all providers (code-generated)
- Use `@Riverpod(keepAlive: true)` for persistent state across screens
- Use `autodispose` (default) for screen-scoped state
- Notifiers extend generated base classes (e.g., `_$PhoneInputNotifier`)
- Never use BLoC, Cubit, or ChangeNotifier — Riverpod only

### Data Models
- All models use `@freezed` for immutability
- Enums for fixed selections (Gender, SexualOrientation, DatingPreference, etc.)
- Run `flutter pub run build_runner build --delete-conflicting-outputs` after model changes

### UI / Design System
- Colors: `AppColors.brandDark` (#9B631C) → `AppColors.brandLight` (#E3BD63) gold gradient
- Background: `AppColors.cream` (#FFFFF6)
- Typography: Playfair Display Bold 28px (headings), Inter 14-16px (body)
- Spacing: 4px base grid via `AppSpacing` (x1=4, x2=8, x3=12, x4=16, x6=24, x8=32)
- Radius: `AppRadius.small` (4), `.medium` (8), `.large` (16), `.round` (999)
- All reusable widgets in `lib/widgets/` — prefer composing existing widgets over creating new ones

### Coding Standards
- Prefer `const` constructors wherever possible
- Use `ConsumerWidget` or `HookConsumerWidget` for screens that read providers
- Keep screens thin — business logic in providers, UI composition in widgets
- SVG assets in `assets/images/` subfolders, referenced via `flutter_svg`
- No hardcoded strings in UI — extract to constants or future l10n

### Testing
- Tests in `test/` mirroring `lib/` structure
- Widget tests use `ProviderScope` with overrides for mocking
- Run: `flutter test`
- Run with coverage: `flutter test --coverage`

### Git Workflow
- Main branch: `main`
- Feature branches: `feature/<description>`
- Refactor branches: `refactor/<description>`
- PR-based workflow into `main`

## Commands
```bash
# Run app
flutter run

# Run tests
flutter test

# Run code generation (after model/provider changes)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch code generation
flutter pub run build_runner watch --delete-conflicting-outputs

# Analyze
flutter analyze

# Get dependencies
flutter pub get
```

## Security
- NEVER read, display, log, or commit files matching: `.env*`, `*.pem`, `*.key`, `*.p12`, `*.jks`, `*.keystore`, `key.properties`, `local.properties`, `google-services.json`, `GoogleService-Info.plist`, `*credentials*`, `*secrets*`, `*token*.json`
- NEVER dump environment variables (`printenv`, `echo $VAR`, `set | grep`)
- NEVER hardcode API keys, tokens, or secrets in source code
- If a file looks like it contains secrets, stop and ask the user before proceeding
- Deny rules in `.claude/settings.local.json` enforce this at the tool level

## Do NOT
- Do not use BLoC, Cubit, or Provider (we use Riverpod exclusively)
- Do not manually edit `.freezed.dart` or `.g.dart` files — they are generated
- Do not add new dependencies without discussing the rationale
- Do not create new widget files for one-off UI — inline or compose existing widgets
- Do not hardcode colors/spacing — use AppColors, AppSpacing, AppRadius tokens
- Do not skip running `build_runner` after changing `@freezed` or `@riverpod` annotated files
