---
name: audit-deps
description: Audit pubspec.yaml for outdated, unused, or conflicting dependencies. Use before releases or periodically.
allowed-tools: Bash(flutter pub outdated*), Bash(flutter pub deps*), Read, Grep, Glob
---

# Dependency Auditor

Audit project dependencies for issues.

## Steps

1. Run `flutter pub outdated` to check for newer versions
2. Read `pubspec.yaml`
3. Cross-reference each dependency against actual imports in `lib/`:
   - Grep for `import 'package:<dep_name>/` across all `.dart` files
   - Flag packages in `pubspec.yaml` with zero imports as potentially unused
4. Check for version conflicts: run `flutter pub deps` and look for resolution issues

## Report Format

### Outdated Packages
| Package | Current | Latest | Breaking? |
|---------|---------|--------|-----------|

### Potentially Unused
| Package | Declared In | Imports Found |
|---------|-------------|---------------|

### Version Conflicts
List any packages with forced resolution or incompatible constraints.

## Key Dependencies to Watch
- `flutter_riverpod` / `riverpod_annotation` / `hooks_riverpod` — must be same major version
- `freezed_annotation` / `freezed` — must be compatible
- `go_router` — check for breaking API changes on major bumps
- `build_runner` / `riverpod_generator` / `json_serializable` — dev deps, keep current
