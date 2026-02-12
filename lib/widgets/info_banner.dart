/// Info Banner Widget
/// Displays informational messages with gradient icon
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';

/// Icon style for InfoBanner
enum InfoBannerIcon {
  /// SVG asset icon (used in verification screens)
  svg,

  /// Gradient circle with Material info icon (used in onboarding screens)
  gradientCircle,
}

class InfoBanner extends StatelessWidget {
  final String message;
  final InfoBannerIcon iconStyle;

  const InfoBanner({
    super.key,
    required this.message,
    this.iconStyle = InfoBannerIcon.svg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: iconStyle == InfoBannerIcon.svg ? Colors.white : null,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(
          color: AppColors.brandDark,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: iconStyle == InfoBannerIcon.svg
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          _buildIcon(),
          const SizedBox(width: AppSpacing.x4),
          // Message text
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    switch (iconStyle) {
      case InfoBannerIcon.svg:
        return SvgPicture.asset(
          'assets/images/InformationIconContainer/InformationIconContainer.svg',
          width: 24,
          height: 24,
          fit: BoxFit.contain,
        );
      case InfoBannerIcon.gradientCircle:
        return Container(
          padding: const EdgeInsets.all(AppSpacing.x2),
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
            shape: BoxShape.circle,
            boxShadow: AppShadows.pressedShadow,
          ),
          child: const Icon(
            Icons.info_outline,
            size: 12,
            color: Colors.white,
          ),
        );
    }
  }
}
