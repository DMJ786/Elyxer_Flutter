/// Info Banner Widget
/// Displays informational messages with custom SVG icon
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';

class InfoBanner extends StatelessWidget {
  final String message;
  final IconData? icon;

  const InfoBanner({
    super.key,
    required this.message,
    this.icon,
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
          // Custom SVG icon
          SvgPicture.asset(
            'assets/images/InformationIconContainer/InformationIconContainer.svg',
            width: 36,
            height: 36,
          ),
          const SizedBox(width: AppSpacing.x3),
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
