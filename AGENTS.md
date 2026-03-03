# Elyxer Flutter — Agent & Skill Definitions

## Agents

### 1. flutter-test-runner
**Purpose**: Run Flutter tests and report results with coverage metrics.
**When to use**: After writing or modifying any Dart code, provider, widget, or screen.
**Tools**: Bash
**Instructions**:
- Run `flutter test` from the project root
- If tests fail, report the failing test file, test name, and error message
- If all pass, report count of tests passed
- For coverage: run `flutter test --coverage` and summarize `coverage/lcov.info`
- Never modify test files — only run and report

### 2. flutter-analyzer
**Purpose**: Run static analysis and lint checks.
**When to use**: Before committing or when reviewing code quality.
**Tools**: Bash
**Instructions**:
- Run `flutter analyze` from project root
- Report any errors, warnings, or info-level issues with file paths and line numbers
- Group issues by severity (error > warning > info)
- Suggest fixes for common issues (unused imports, missing const, type mismatches)

### 3. build-runner
**Purpose**: Run code generation for Freezed models and Riverpod providers.
**When to use**: After any change to files with `@freezed`, `@riverpod`, or `@Riverpod` annotations.
**Tools**: Bash
**Instructions**:
- Run `flutter pub run build_runner build --delete-conflicting-outputs`
- Report success or list any code generation errors
- If errors occur, check that annotation packages match generated file expectations
- Key generated files: `*.freezed.dart`, `*.g.dart` in models/ and providers/

### 4. figma-design-reviewer
**Purpose**: Compare implementation against Figma design specifications.
**When to use**: After building or modifying a screen/widget, to verify design fidelity.
**Tools**: WebFetch, Read, Grep
**Instructions**:
- Read the target screen/widget Dart file
- Read `lib/theme/app_theme.dart` for design token definitions
- Verify colors match `AppColors` tokens, spacing matches `AppSpacing`, radius matches `AppRadius`
- Check typography uses correct `AppTheme.textTheme` styles (Playfair Display for headings, Inter for body)
- Flag any hardcoded values that should use design tokens
- Compare against Figma if URL is provided

### 5. widget-test-writer
**Purpose**: Generate widget tests for screens and reusable widgets.
**When to use**: When a screen or widget lacks test coverage.
**Tools**: Read, Write, Grep, Glob
**Instructions**:
- Read the target widget/screen file to understand its structure
- Read existing tests in `test/` for patterns and conventions
- Tests must use `ProviderScope` with overrides for any Riverpod providers
- Use `MaterialApp.router` wrapper for screens that depend on GoRouter
- Test structure: group by feature, use descriptive test names
- Place test file mirroring `lib/` path (e.g., `lib/widgets/foo.dart` → `test/widgets/foo_test.dart`)
- Import `flutter_test` and `flutter_riverpod` for testing

### 6. provider-test-writer
**Purpose**: Generate provider/notifier tests for business logic.
**When to use**: When a provider or notifier lacks test coverage.
**Tools**: Read, Write, Grep, Glob
**Instructions**:
- Read the target provider file and its associated model file
- Read `test/providers/onboarding_provider_test.dart` as the reference pattern
- Use `ProviderContainer` for testing providers in isolation
- Test state transitions, validation logic, edge cases, and error states
- Each notifier method should have at least one happy-path and one edge-case test
- Use `container.read()` and `container.listen()` patterns

### 7. route-guard-reviewer
**Purpose**: Audit GoRouter routes for proper guards and navigation safety.
**When to use**: When adding new routes or reviewing navigation flow integrity.
**Tools**: Read, Grep
**Instructions**:
- Read `lib/routes/app_router.dart`
- Check that routes receiving `state.extra` data have null-safe fallbacks
- Verify route names are unique and paths don't conflict
- Ensure screens that require prior data (e.g., OTP screens need phone/email) have redirect guards
- Report any routes missing error handling

### 8. dependency-auditor
**Purpose**: Review pubspec.yaml for outdated, unused, or conflicting dependencies.
**When to use**: Periodically or before a release.
**Tools**: Bash, Read
**Instructions**:
- Run `flutter pub outdated` to check for newer versions
- Read `pubspec.yaml` and cross-reference imports across `lib/` to find unused packages
- Check for version conflicts or overly loose constraints
- Report findings with upgrade recommendations and breaking change warnings

### 9. screen-scaffolder
**Purpose**: Generate boilerplate for new onboarding/verification screens following existing patterns.
**When to use**: When adding a new screen to any module.
**Tools**: Read, Write, Glob
**Instructions**:
- Read an existing screen in the same module as a template (e.g., `gender_selection_screen.dart` for Module 1)
- Generate new screen with: ConsumerWidget/HookConsumerWidget, proper theme usage, InfoBanner if needed
- Add corresponding route in `app_router.dart`
- Add step to the module's enum and provider if applicable
- Follow naming convention: `<feature>_screen.dart` in the appropriate module folder

### 10. ci-cd-setup
**Purpose**: Generate GitHub Actions workflows for Flutter CI/CD.
**When to use**: When setting up or modifying CI/CD pipelines.
**Tools**: Read, Write, Glob
**Instructions**:
- Create `.github/workflows/flutter-ci.yml` with jobs for:
  - `flutter pub get`
  - `flutter analyze`
  - `flutter test --coverage`
  - `flutter build apk --release` (Android)
  - `flutter build ios --release --no-codesign` (iOS, if applicable)
- Use `subosito/flutter-action@v2` for Flutter setup
- Cache pub dependencies for speed
- Trigger on push to `main` and all PRs

---

## Skills (User-Invocable)

### /test
Run all Flutter tests and report results.
```
flutter test
```

### /test-coverage
Run tests with coverage and report summary.
```
flutter test --coverage
```

### /analyze
Run Flutter static analysis.
```
flutter analyze
```

### /build-runner
Run code generation for Freezed and Riverpod.
```
flutter pub run build_runner build --delete-conflicting-outputs
```

### /build-apk
Build a release APK.
```
flutter build apk --release
```

### /outdated
Check for outdated dependencies.
```
flutter pub outdated
```

---

## Agent Selection Guide

| Task | Agent |
|------|-------|
| Just wrote/changed code | flutter-test-runner |
| Changed `@freezed` or `@riverpod` files | build-runner |
| Building a new screen | screen-scaffolder |
| Need tests for a widget | widget-test-writer |
| Need tests for a provider | provider-test-writer |
| Checking design fidelity | figma-design-reviewer |
| Pre-commit quality check | flutter-analyzer |
| Adding/changing routes | route-guard-reviewer |
| Before release | dependency-auditor |
| Setting up CI | ci-cd-setup |
