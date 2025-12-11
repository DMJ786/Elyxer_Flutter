/// Info Banner Widget
/// Displays informational messages with gradient icon
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class InfoBanner extends StatelessWidget {
  final String message;

  const InfoBanner({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(
          color: AppColors.brandDark,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient icon container
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: BorderRadius.circular(AppRadius.round),
              boxShadow: AppShadows.pressedShadow,
            ),
            child: const Icon(
              Icons.info_outline,
              size: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          // Message text
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                height: 1.43,
                color: AppColors.interactive400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
