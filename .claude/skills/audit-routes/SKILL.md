---
name: audit-routes
description: Audit GoRouter routes for guard safety, missing redirects, and navigation issues. Use when adding or reviewing routes.
allowed-tools: Read, Grep, Glob
---

# Route Guard Auditor

Audit all GoRouter routes for navigation safety.

## Steps

1. Read `lib/routes/app_router.dart`
2. Grep all `context.go(`, `context.push(`, `context.goNamed(`, `context.pushNamed(` calls across `lib/`
3. Check each route for:

### Safety Checks

| Check | What to Verify |
|-------|---------------|
| **Extra data null safety** | Routes using `state.extra` must have null-safe fallbacks with `as Type?` and `?? default` |
| **Route name uniqueness** | No duplicate `name:` values |
| **Path conflicts** | No overlapping or ambiguous paths |
| **Missing routes** | Navigation calls referencing routes that don't exist |
| **Dead routes** | Routes defined but never navigated to |
| **Guard presence** | Screens requiring prior data (OTP screens) should have `redirect` guards |

### Required Guards for This Project
- `/phone-otp` — Must have phoneNumber, should redirect to `/` if missing
- `/email-otp` — Must have email, should redirect to `/email-input` if missing
- `/complete` — Should only be reachable after verification flow

## Output
Report a table: Route | Issue | Severity | Suggested Fix
