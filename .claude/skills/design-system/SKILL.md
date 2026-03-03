---
name: design-system
description: Elyxer design system tokens and UI conventions. Auto-loaded when building screens, widgets, or styling components.
user-invocable: false
---

# Design System — Elyxer Flutter

All UI must use these tokens from `lib/theme/app_theme.dart`. Never hardcode values.

## Colors (`AppColors`)

| Token | Hex | Usage |
|-------|-----|-------|
| `cream` | #FFFFF6 | Page background |
| `brandDark` | #9B631C | Gradient start (gold) |
| `brandLight` | #E3BD63 | Gradient end (gold) |
| `brandGradient` | LinearGradient | Buttons, accents |
| `interactive500` | #000000 | Primary text |
| `interactive400` | #333333 | Secondary text |
| `interactive300` | #666666 | Tertiary/hint text |
| `interactive200` | #B3B3B3 | Placeholder text |
| `interactive100` | #E0E0E0 | Borders, dividers |
| `interactive50` | #F5F5F5 | Surface backgrounds |
| `error` | #EF4444 | Error states |
| `success` | #10B981 | Success states |
| `warning` | #F59E0B | Warning states |
| `info` / `focus` | #3B82F6 | Info banners, focus rings |

## Spacing (`AppSpacing`) — 4px base grid

| Token | Value | Common Use |
|-------|-------|------------|
| `x1` | 4px | Minimal gap |
| `x2` | 8px | Tight spacing |
| `x3` | 12px | Small gap |
| `x4` | 16px | Standard padding |
| `x5` | 20px | Medium gap |
| `x6` | 24px | Section padding |
| `x8` | 32px | Large spacing |
| `x14` | 56px | Extra large |

## Radius (`AppRadius`)

| Token | Value | Usage |
|-------|-------|-------|
| `small` | 4px | Subtle rounding |
| `medium` | 8px | Cards, inputs |
| `large` | 16px | Modals, sheets |
| `round` | 999px | Pills, avatars |

## Typography

| Style | Font | Size | Weight |
|-------|------|------|--------|
| `headlineLarge` | Playfair Display | 28px | Bold |
| `bodyLarge` | Inter | 16px | Regular |
| `bodyMedium` | Inter | 14px | Regular |
| `bodySmall` | Inter | 12px | Regular |
| `labelLarge` | Inter | 16px | SemiBold (buttons) |

## Reusable Widgets

Always check `lib/widgets/` before creating new components:
- `InfoBanner` — info/warning messages with icon
- `NextButton` — gradient CTA button (14% width responsive)
- `OtpVerificationContent` — full OTP flow UI
- `PhoneNumberInput` — phone input with country code
- `ProfileVisibilityCheckbox` — custom checkbox
- `GradientLinkText` / `GradientTextLink` — gradient-styled text links
- `ProgressBar` — progress visualization
- `OnboardingProgressIndicator` / `OrientationProgressIndicator` / `Module4ProgressIndicator`
