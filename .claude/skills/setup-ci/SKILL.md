---
name: setup-ci
description: Generate GitHub Actions CI/CD workflows for Flutter. Use when setting up or modifying CI pipelines.
disable-model-invocation: true
allowed-tools: Read, Write, Glob
---

# CI/CD Setup — GitHub Actions

Generate or update GitHub Actions workflow for this Flutter project.

## Steps

1. Check if `.github/workflows/` exists
2. Create `.github/workflows/flutter-ci.yml`

## Workflow Template

```yaml
name: Flutter CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  analyze-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.8.0'
          channel: 'stable'
          cache: true

      - name: Get dependencies
        run: flutter pub get

      - name: Run code generation
        run: flutter pub run build_runner build --delete-conflicting-outputs

      - name: Analyze
        run: flutter analyze

      - name: Run tests
        run: flutter test --coverage

      - name: Check coverage threshold
        run: |
          COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep 'lines' | awk '{print $2}' | tr -d '%')
          echo "Coverage: $COVERAGE%"

  build-android:
    needs: analyze-and-test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.8.0'
          channel: 'stable'
          cache: true

      - run: flutter pub get
      - run: flutter pub run build_runner build --delete-conflicting-outputs
      - run: flutter build apk --release

      - uses: actions/upload-artifact@v4
        with:
          name: release-apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

## Post-Setup
- Verify workflow runs on next push/PR
- Add branch protection rule requiring CI to pass
- Consider adding iOS build job if targeting iOS
