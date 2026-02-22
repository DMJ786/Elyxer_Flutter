/// Profile Visibility Checkbox Widget
/// Reusable "Show on your profile" checkbox row
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileVisibilityCheckbox extends StatelessWidget {
  final bool value;
  final VoidCallback onToggle;
  final String label;

  const ProfileVisibilityCheckbox({
    super.key,
    required this.value,
    required this.onToggle,
    this.label = 'Show on your profile',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 44,
          height: 44,
          child: Checkbox(
            value: value,
            onChanged: (_) => onToggle(),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
