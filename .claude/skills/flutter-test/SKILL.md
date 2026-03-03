---
name: flutter-test
description: Run Flutter tests and report results. Use when testing code changes, verifying fixes, or checking test coverage.
allowed-tools: Bash(flutter test*), Read, Grep
argument-hint: [file-or-directory]
---

# Flutter Test Runner

Run Flutter tests for `$ARGUMENTS`. If no arguments provided, test the entire project.

## Steps

1. Run `flutter test $ARGUMENTS --reporter expanded` for detailed output
2. If tests fail:
   - Report each failing test: file path, test name, error message, and line number
   - Suggest specific fixes based on the error type
3. If all pass:
   - Report total count of tests passed
   - Report time taken

## For Coverage

If the user asks for coverage or uses `/flutter-test --coverage`:
1. Run `flutter test --coverage`
2. Parse `coverage/lcov.info` and summarize:
   - Total lines covered / total lines
   - Files with lowest coverage
   - Untested files

## Common Fixes
- `ProviderScope` missing → Wrap test widget in `ProviderScope(child: ...)`
- `GoRouter` error → Use `MaterialApp.router` with `routerConfig` in test
- `MediaQuery` error → Wrap in `MaterialApp` or `MediaQuery`
- Asset not found → Add `DefaultAssetBundle` mock or skip asset-dependent tests
