---
name: flutter-analyze
description: Run Flutter static analysis and lint checks. Use before committing or when reviewing code quality.
allowed-tools: Bash(flutter analyze*), Read
---

# Flutter Analyzer

Run static analysis on the project.

## Steps

1. Run `flutter analyze`
2. Group results by severity: **error** > **warning** > **info**
3. For each issue, report:
   - Severity level
   - File path and line number
   - Issue description
   - Suggested fix

## Auto-Fix Patterns

| Issue | Fix |
|-------|-----|
| `prefer_const_constructors` | Add `const` keyword |
| `unused_import` | Remove the import line |
| `prefer_const_declarations` | Change `final` to `const` |
| `avoid_print` | Replace with proper logging or remove |
| `unnecessary_this` | Remove `this.` prefix |
| `prefer_single_quotes` | Replace double quotes with single quotes |

## Rules
- Never suppress lint warnings without explaining why
- Fix all errors before committing
- Warnings should be addressed unless there's a documented reason to skip
