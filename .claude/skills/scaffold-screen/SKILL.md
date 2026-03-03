---
name: scaffold-screen
description: Scaffold a new onboarding or verification screen following existing patterns. Use when adding a new screen to any module.
allowed-tools: Read, Write, Grep, Glob
argument-hint: [screen-name] [module]
---

# Screen Scaffolder

Generate a new screen called `$ARGUMENTS` following project conventions.

## Steps

1. Determine which module the screen belongs to (verification, onboarding, orientation, module4)
2. Read an existing screen from that module as a template:
   - Verification: `lib/screens/username_screen.dart`
   - Onboarding Module 1: `lib/screens/onboarding/gender_selection_screen.dart`
   - Orientation Module 2: `lib/screens/orientation/sexual_orientation_screen.dart`
   - Module 4: `lib/screens/onboarding/education_entry_screen.dart`
3. Read `lib/theme/app_theme.dart` for design tokens
4. Generate the new screen file

## Screen Template Pattern

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../widgets/info_banner.dart';
import '../../widgets/next_button.dart';

class NewScreen extends ConsumerWidget {
  const NewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.x6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.x8),
              // Heading with Playfair Display
              Text('Screen Title',
                style: Theme.of(context).textTheme.headlineLarge),
              SizedBox(height: AppSpacing.x4),
              // Content area
              // ...
              const Spacer(),
              // Next button at bottom
              NextButton(onPressed: () { /* navigate */ }),
              SizedBox(height: AppSpacing.x6),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Post-Generation Checklist
- [ ] Add route in `lib/routes/app_router.dart`
- [ ] Add step enum value if part of a module flow
- [ ] Update module's notifier for navigation
- [ ] Add to progress indicator widget
- [ ] Run `/build-runner` if new providers/models were added
