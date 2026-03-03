---
name: figma-review
description: Compare a screen or widget implementation against Figma design specs and design tokens. Use when verifying design fidelity.
allowed-tools: Read, Grep, Glob, WebFetch(domain:www.figma.com)
argument-hint: [screen-or-widget-file]
---

# Figma Design Review

Compare implementation of `$ARGUMENTS` against the project's design system.

## Steps

1. Read the target file: `$ARGUMENTS`
2. Read `lib/theme/app_theme.dart` for design tokens
3. Check for violations:

### Color Compliance
- All colors must use `AppColors.*` tokens, never hardcoded hex values
- Brand gradient: `AppColors.brandGradient` (dark #9B631C → light #E3BD63)
- Background: `AppColors.cream` (#FFFFF6)
- Text: `AppColors.interactive500` (black), `interactive400` (dark gray), `interactive300` (medium)
- Borders: `AppColors.interactive100`
- Errors: `AppColors.error` (#EF4444)

### Spacing Compliance
- All spacing must use `AppSpacing.*` tokens (4px base grid)
- Common: `x2` (8px), `x3` (12px), `x4` (16px), `x6` (24px), `x8` (32px)
- No hardcoded padding/margin values

### Typography Compliance
- Headings: Playfair Display Bold 28px → `AppTheme.textTheme.headlineLarge`
- Body Large: Inter 16px → `AppTheme.textTheme.bodyLarge`
- Body Medium: Inter 14px → `AppTheme.textTheme.bodyMedium`
- Button text: Inter SemiBold 16px → `AppTheme.textTheme.labelLarge`

### Radius Compliance
- Use `AppRadius.small` (4), `.medium` (8), `.large` (16), `.round` (999)

## Output
Report a table of violations with: line number, current value, expected token, severity (error/warning).
