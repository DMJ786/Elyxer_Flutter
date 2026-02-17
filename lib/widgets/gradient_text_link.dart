/// Gradient Text Link Widget
/// Reusable widget for gradient-styled clickable text with underline
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GradientTextLink extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final TextStyle? style;

  const GradientTextLink({
    super.key,
    required this.text,
    this.onTap,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = theme.textTheme.labelMedium?.copyWith(
      decoration: TextDecoration.underline,
      color: Colors.white,
    );

    return GestureDetector(
      onTap: onTap,
      child: ShaderMask(
        shaderCallback: (bounds) => AppColors.brandGradient.createShader(bounds),
        child: Text(
          text,
          style: style ?? defaultStyle,
        ),
      ),
    );
  }
}
