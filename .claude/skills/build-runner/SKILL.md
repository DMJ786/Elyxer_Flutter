---
name: build-runner
description: Run code generation for Freezed models and Riverpod providers. Use after changing @freezed, @riverpod, or @Riverpod annotated files.
allowed-tools: Bash(flutter pub run build_runner*), Bash(dart run build_runner*), Read, Grep
---

# Build Runner — Code Generation

Run Freezed + Riverpod code generation.

## Steps

1. Run `flutter pub run build_runner build --delete-conflicting-outputs`
2. If successful, report which files were generated/updated
3. If errors occur:
   - Parse the build_runner error output
   - Identify the source file causing the issue
   - Check annotation imports (`freezed_annotation`, `riverpod_annotation`, `json_annotation`)
   - Suggest fixes

## When This Is Needed

Run build_runner after ANY change to files containing:
- `@freezed` / `@Freezed()` annotations → generates `.freezed.dart`
- `@riverpod` / `@Riverpod()` annotations → generates `.g.dart`
- `@JsonSerializable()` annotations → generates `.g.dart`

## Key Generated Files in This Project
- `lib/models/verification_models.freezed.dart`
- `lib/models/verification_models.g.dart`
- `lib/models/onboarding_models.freezed.dart`
- `lib/providers/verification_provider.g.dart`
- `lib/providers/onboarding_provider.g.dart`

## Common Errors
- **Part directive mismatch**: Ensure `part 'filename.freezed.dart';` matches actual filename
- **Missing import**: Add `import 'package:freezed_annotation/freezed_annotation.dart';`
- **Riverpod gen error**: Ensure `part 'filename.g.dart';` is present and method signature matches
- **Stale output**: Use `--delete-conflicting-outputs` flag to clean stale generated files
