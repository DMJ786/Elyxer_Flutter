/// Next Button Widget
/// Custom SVG button positioned at bottom right corner
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';

class NextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool isLoading;

  const NextButton({
    super.key,
    this.onPressed,
    this.isEnabled = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final canPress = isEnabled && !isLoading;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x8, right: AppSpacing.x4),
      child: GestureDetector(
        onTap: canPress ? onPressed : null,
        child: SizedBox(
          width: 64,
          height: 64,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                canPress
                    ? 'assets/images/NextButton/Default.svg'
                    : 'assets/images/NextButton/Disabled.svg',
                width: 64,
                height: 64,
              ),
              if (isLoading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
